local ThemeUtil={}

local context=activity or service
local onColorChangedListeners={}
local selectableItemBackgroundBorderless

function ThemeUtil.onColorChangedListener(colorName,color)
  local listeners=onColorChangedListeners[colorName]
  if listeners then
    for index,content in ipairs(listeners) do
      content(color)
    end
  end
  return color
end

function ThemeUtil.addColorChangedListener(colorName,event)
  local listeners=onColorChangedListeners[colorName]
  if not(listeners) then
    listeners={}
    onColorChangedListeners[colorName]=listeners
  end
  table.insert(listeners,event)
  return event
end


function ThemeUtil.isNightMode()
  import "android.content.res.Configuration"
  return (context.getResources().getConfiguration().uiMode)==Configuration.UI_MODE_NIGHT_YES+1
end

function ThemeUtil.refreshThemeColor(colorList)
  local array = context.getTheme().obtainStyledAttributes({
    android.R.attr.textColorTertiary,
    android.R.attr.textColorPrimary,
    android.R.attr.colorPrimary,
    android.R.attr.colorPrimaryDark,
    android.R.attr.colorAccent,
    android.R.attr.navigationBarColor,
    android.R.attr.statusBarColor,
    android.R.attr.colorButtonNormal,
    android.R.attr.windowBackground,
    android.R.attr.textColorSecondary,
    R.attr.rippleColorPrimary,
    R.attr.rippleColorAccent,
    R.attr.floatingActionButtonBackgroundColor,
  })
  local colorList=colorList or theme.color
  colorList.textColorTertiary=array.getColor(0,0)
  colorList.textColorPrimary=array.getColor(1,0)
  colorList.colorPrimary=array.getColor(2,0)
  colorList.colorPrimaryDark=array.getColor(3,0)
  colorList.colorAccent=array.getColor(4,0)
  colorList.navigationBarColor=array.getColor(5,0)
  colorList.statusBarColor=array.getColor(6,0)
  colorList.colorButtonNormal=array.getColor(7,0)
  colorList.windowBackground=array.getColor(8,0)
  colorList.textColorSecondary=array.getColor(9,0)
  colorList.rippleColorPrimary=array.getColor(10,0)
  colorList.rippleColorAccent=array.getColor(11,0)
  colorList.floatingActionButtonBackgroundColor=array.getColor(12,0)
  array.recycle()

  local array = context.getTheme().obtainStyledAttributes({
    android.R.attr.selectableItemBackgroundBorderless,
  })
  selectableItemBackgroundBorderless=array.getResourceId(0,0)
  array.recycle()
  return colorList
end

function ThemeUtil.setNavigationbarColor(color)
  theme.color.navigationBarColor=color
  context.getWindow().setNavigationBarColor(color)
  ThemeUtil.onColorChangedListener("navigationBarColor",color)
  return color
end

function ThemeUtil.getRippleDrawable(color)
  import "android.content.res.ColorStateList"
  local drawable=context.getResources().getDrawable(selectableItemBackgroundBorderless)
  if color then
    drawable.setColor(ColorStateList(int[0].class{int{}},int{color}))
  end
  return drawable
end

return ThemeUtil