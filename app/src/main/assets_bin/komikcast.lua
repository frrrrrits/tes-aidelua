import "cn.wanghaomiao.xpath.model.*"
import "org.jsoup.*"
import "com.kn.MyLuaAdapter"

items = {--Items
  LinearLayout;
  layout_width="match_parent";
  layout_height="match_parent";
  {
    CardView;
    backgroundColor="0xffffffff";
    layout_width="match_parent";
    CardElevation="2dp";
    layout_height="220dp";
    layout_margin="21dp";
    radius="3dp";
    {
      ImageView;
      scaleType="centerCrop";
      layout_width="match_parent";
      layout_height="match_parent";
      id="mBannerImage";
    };
    {
      LinearLayout;
      layout_width="match_parent";
      layout_height="match_parent";
      gravity="bottom";
      {
        LinearLayout;
        layout_width="match_parent";
        orientation="vertical";
        layout_height="63dp";
        gravity="center|left";
        backgroundColor="0x6D000000";
        {
          TextView;
          Typeface=Typeface.DEFAULT_BOLD;
          textColor="0xFFFFFFFF";
          maxLines="1";
          layout_marginLeft="9dp";
          singleLine="true";
          ellipsize="end";
          id="mTitleName";
          textSize="17sp";
          layout_margin="4dp";
        };
        {
          LinearLayout;
          layout_width="match_parent";
          layout_height="match_parent";
          {
            TextView;
            id="mTitleChapter";
            textColor="0xEFFFFFFF";
            layout_marginLeft="9dp";
            layout_marginRight="3dp";
            textSize="15sp";
          };
          {
            TextView;
            id="mP";
            textColor="0xBFFFFFFF";
            layout_marginLeft="3dp";
            layout_marginRight="3dp";
            textSize="15sp";
          };
          {
            TextView;
            id="mIsColor";
            textColor="0xFFFFD538";
            layout_marginLeft="3dp";
            layout_marginRight="3dp";
            textSize="15sp";
          };
        };
        {
          TextView;
          layout_width="0dp";
          layout_height="0dp";
          id="mViewLink";
          textColor="0x00FFFFFF";
          textSize="0sp";
        };
      };
    };
    {
      LinearLayout;
      layout_margin="8dp";
      layout_width="wrap_content";
      layout_height="wrap_content";
      layout_gravity="top|left";
      {
        MaterialCardView;
        radius="2dp";
        elevation="2dp";
        layout_margin="3dp";
        layout_width="37dp";
        layout_height="25dp";
        {
          ImageView;
          scaleType="fitXY",
          id="mTypeFlag";
          layout_width="match_parent";
          layout_height="match_parent";
        };
      };
    };
  };
};

ids={mSwipeRefresh1}

for view = 1,#ids do
  mColor = {tonumber(0xFFFFFFFF)}
  ids[view].setColorSchemeColors(mColor)
  ids[view].setSize(SwipeRefreshLayout.DEFAULT)
  ids[view].setDistanceToTriggerSync(200);
  ids[view].setProgressBackgroundColorSchemeColor(0xFF6200EE)
  ids[view].setProgressViewOffset(true,0, 70)
end

mUpdateAdapter = MyLuaAdapter(activity,items)
mListView1.Adapter = mUpdateAdapter

listdraw=RippleDrawable(ColorStateList(int[0].class{int{}},int{0x276200EE}),nil,ColorDrawable(0xFFFFFFFF))
mListView1.setSelector(listdraw)

mColorDw = ColorDrawable(0x00000000)
mListView1.setDivider(mColorDw)
mListView1.setDividerHeight(dpTopx("1.3dp"))

baseUrl = "https://westmanga.info"

function newUpdate(url)
  mSwipeRefresh1.setRefreshing(true)
  isLoadMore=false
  Http.get(url,function(a,b,c)
    if 0<a and a<400 then
      mSwipeRefresh1.setRefreshing(false)
      body = Jsoup.parse(b)
      classBody = body.getElementsByClass("bsx")
      if tostring(classBody) == nil or tostring(classBody)=="" then
        showSnackBar(mainLay,"Ada yang error")
       elseif tostring(classBody) then
        tableBody = luajava.astable(classBody)
        for k,v in ipairs(tableBody)
          fragBody = Jsoup.parseBodyFragment(tostring(v))
          -- kalau ada error di web nya hedeuh ribet ntar jadi w buat statement if then karna w pemula kurang ilmu
          mUpdateLink = fragBody.getElementsByTag("a").attr("href")
          if mUpdateLink == nil then
            mUpdateLink = "Error" else
            mUpdateLink=mUpdateLink
          end
          mUpdateTitle = fragBody.getElementsByClass("tt").text()
          if mUpdateTitle == nil then
            mUpdateTitle = "Error" else
            mUpdateTitle=mUpdateTitle
          end
          mUpdateBanner = fragBody.getElementsByTag("img").attr("src")
          if mUpdateBanner == nil then
            mUpdateBanner = activity.getLuaDir().."/res/warning.png" else
            mUpdateBanner = tostring(mUpdateBanner):gsub("resize=165,225","")
          end
          mUpdateTitleChap = fragBody.getElementsByClass("epxs").text()
          if mUpdateTitleChap == nil then
            mUpdateTitleChap = "Error" else
            mUpdateTitleChap=mUpdateTitleChap
          end
          mUpdateType = tostring(fragBody):match([[<span class="type (.-)"]])
          if mUpdateType == nil then mUpdateType = activity.getLuaDir().."/res/warning.png"
           elseif tostring(mUpdateType) == "Manhwa" then
            mUpdateType = activity.getLuaDir().."/res/korea_flag.png"
           elseif tostring(mUpdateType) == "Manhua" then
            mUpdateType = activity.getLuaDir().."/res/china_flag.png"
           elseif tostring(mUpdateType) == "Manga" then
            mUpdateType = activity.getLuaDir().."/res/japan_flag.png"
          end
          mUpdateIsColor = tostring(fragBody):match([[<span class="colored"]])
          if mUpdateIsColor == nil then
            mUpdateIsColor = "" pp = "" else
            mUpdateIsColor = "Warna" pp = "•"
          end
          mUpdateAdapter.add{
            mBannerImage = mUpdateBanner,
            mTitleName = mUpdateTitle,
            mTitleChapter = mUpdateTitleChap,
            mViewLink = mUpdateLink,
            mTypeFlag = mUpdateType,
            mIsColor = mUpdateIsColor,
            mP = pp
          }
        end
      end
     else
      showSnackBar(mainLay,"Pastikan anda terhubung ke internet")
    end
  end)
end

isPage = 1
updateUrl = baseUrl.."/manga/?page=1&order=update"
newUpdate(updateUrl)

isLoadMore=false
mListView1.setOnScrollListener(AbsListView.OnScrollListener{
  lastposition = 0;
  onScrollStateChanged=function(l,s)
    if mListView1.getLastVisiblePosition()==mListView1.getCount()-1 then
      if isLoadMore==false then
        isLoadMore = true
        isPage = isPage+1
        updateUrl = baseUrl.."/manga/?page="..isPage.."&order=update"
        newUpdate(updateUrl)
       elseif isLoadMore==true then
      end
    end
  end,
})
