using UnityEngine;
using UnityEngine.UI;

[ExecuteAlways, RequireComponent(typeof(Image), typeof(AspectRatioFitter))]
public class ImageFitter : MonoBehaviour {
	Image image;
	AspectRatioFitter fitter;

	void Start() {
		if(!Application.isPlaying)
			return;
		Set();
	}

	void Update() {
		if(Application.isPlaying)
			return;
		Set();
	}

	void Set() {
		if(fitter == null)
			fitter = GetComponent<AspectRatioFitter>();
		if(image == null)
			image = GetComponent<Image>();
		if(image.sprite == null)
			return;
		switch(fitter.aspectMode) {
			case AspectRatioFitter.AspectMode.WidthControlsHeight:
			case AspectRatioFitter.AspectMode.HeightControlsWidth:
				var rect = image.sprite.textureRect;
				fitter.aspectRatio = rect.width / rect.height;
				break;
			default:
				break;
		}
	}
}
