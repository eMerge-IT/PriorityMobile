<script type="text/javascript">

/***********************************************
* Image Thumbnail Viewer II script- � Dynamic Drive DHTML code library (www.dynamicdrive.com)
* Visit http://www.dynamicDrive.com for hundreds of DHTML scripts
* This notice must stay intact for legal use
***********************************************/

//Specify image paths and optional link (set link to "" for no link):
var dynimages=new Array()
dynimages[0]=["photo1.jpg", "http://www.cnn.com"]
dynimages[1]=["photo2.jpg", "http://www.yahoo.com"]
dynimages[2]=["photo3.jpg", "http://www.google.com"]

//Preload images ("yes" or "no"):
var preloadimg="no"

//Set optional link target to be added to all images with a link:
var optlinktarget=""

//Set image border width
var imgborderwidth=0

//Optionally, change 1.0 and 0.7 below to affect Wipe gradient size and duration in seconds in IE5.5+:
var filterstring="progid:DXImageTransform.Microsoft.GradientWipe(GradientSize=1.0 Duration=0.7)"

///////No need to edit beyond here/////

if (preloadimg=="yes"){
for (x=0; x<dynimages.length; x++){
var myimage=new Image()
myimage.src=dynimages[x][0]
}
}

function returnimgcode(theimg){
var imghtml=""
if (theimg[1]!="")
imghtml='<a href="'+theimg[1]+'" target="'+optlinktarget+'">'
imghtml+='<img src="'+theimg[0]+'" border="'+imgborderwidth+'">'
if (theimg[1]!="")
imghtml+='</a>'
return imghtml
}

function modifyimage(loadarea, imgindex){
if (document.getElementById){
var imgobj=document.getElementById(loadarea)
if (imgobj.filters && window.createPopup){
imgobj.style.filter=filterstring
imgobj.filters[0].Apply()
}
imgobj.innerHTML=returnimgcode(dynimages[imgindex])
if (imgobj.filters && window.createPopup)
imgobj.filters[0].Play()
return false
}
}

</script>