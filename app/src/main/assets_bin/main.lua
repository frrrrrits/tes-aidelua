require "import"
import "importx"

theme={}
theme.color={}

StatService.start(this)

activity.setTitle("Komik Cast")
activity.setTheme(R.style.AppTheme)
activity.setContentView(loadlayout("layout"))

actionBar=activity.getSupportActionBar()

activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE)
activity.getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setStatusBarColor(0xFFFFFFFF).setNavigationBarColor(0xFFFFFFFF);

import "komikcast"
 

local tab
title = {"Manga Terbaru","Populer"}

for i=1, #title do
  tab=mTabsBar.newTab().setText(title[i])
  local tabTag = {}
  tab.tag = tabTag
  mTabsBar.addTab(tab)
  local view=tab.view
  tabTag.view = view
  local textView = view.getChildAt(1)
  tabTag.textView = textView
end

mTabsBar.addOnTabSelectedListener(TabLayout.OnTabSelectedListener({
  onTabSelected=function(tab)
    mPageView.showPage(tab.getPosition())
  end,
  onTabReselected=function(tab)
  end ,
  onTabUnselected=function(tab)
  end
}))

mPageView.setOnPageChangeListener(PageView.OnPageChangeListener{
  onPageScrolled=function(a,b,c)end,
  onPageSelected=function(v)
    mTabsBar.getTabAt(v).select()
  end,
})

Ripple({mOther},0x206200EE,"Circle")

mTabsBar.setSelectedTabIndicatorHeight(dpTopx("3dp"))
mTabsBar.setTabIndicatorFullWidth(false)