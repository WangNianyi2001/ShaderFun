using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(Water))]
public class WaterEditor : Editor {
	public override void OnInspectorGUI() {
		Water Target = target as Water;

		DrawDefaultInspector();

		if(Application.isPlaying) {
			if(GUILayout.Button("Reset"))
				Target.Reset();
		}
	}
}
