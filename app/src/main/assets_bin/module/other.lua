-- type 
function dpTopx(sdp) import "android.util.TypedValue"
  dm=this.getResources().getDisplayMetrics()
  types={px=0,dp=1,sp=2,pt=3,["in"]=4,mm=5}
  n,ty=sdp:match("^(%-?[%.%d]+)(%a%a)$")
  return TypedValue.applyDimension(types[ty],tonumber(n),dm)
end 

-- toast snackebar
function showSnackBar(view,text)
  Snackbar.make(view,text,Snackbar.LENGTH_SHORT).show()
end

-- ripple
xpcall(function()
  ripple = activity.obtainStyledAttributes({android.R.attr.selectableItemBackgroundBorderless}).getResourceId(0,0)
  ripples = activity.obtainStyledAttributes({android.R.attr.selectableItemBackground}).getResourceId(0,0)
end,function()end)

function Ripple(id,color,t)
  import "android.content.res.ColorStateList"
  import "android.graphics.drawable.ColorDrawable"
  import "android.graphics.drawable.GradientDrawable"
  for i=1,#id do
    local ripple
    if t=="Circle" or t==nil then
      if not(RippleCircular) then
        RippleCircular=activity.obtainStyledAttributes({android.R.attr.selectableItemBackgroundBorderless}).getResourceId(0,0)
      end
      ripple=RippleCircular
     elseif t=="Square" then
      if not(RippleSquare) then
        RippleSquare=activity.obtainStyledAttributes({android.R.attr.selectableItemBackground}).getResourceId(0,0)
      end
      ripple=RippleSquare
    end
    local Pretend=activity.Resources.getDrawable(ripple)
    if id[i] then
      id[i].setBackground(Pretend.setColor(ColorStateList(int[0].class{int{}},int{color})))
     else
      return Pretend.setColor(ColorStateList(int[0].class{int{}},int{color}))
    end
  end
end