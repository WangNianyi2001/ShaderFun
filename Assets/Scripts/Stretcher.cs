using UnityEngine;

[ExecuteAlways]
[RequireComponent(typeof(RectTransform))]
public class Stretcher : MonoBehaviour {
	public bool width;
	public bool height;

	void Update() {
		if(Application.isPlaying)
			return;
		if(!(width || height))
			return;
		var rt = transform as RectTransform;
		var size = rt.sizeDelta;
		if(width)
			size.x = (rt.parent as RectTransform).sizeDelta.x;
		if(height)
			size.y = (rt.parent as RectTransform).sizeDelta.y;
		rt.sizeDelta = size;
	}
}
