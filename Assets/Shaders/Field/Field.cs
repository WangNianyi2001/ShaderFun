using UnityEngine;

public static class Field {
	public static Vector2Int Size(this Texture texture) =>
		new Vector2Int(texture.width, texture.height);

	public static RenderTexture Create(Vector2Int res) {
		return RenderTexture.GetTemporary(res.x, res.y);
	}

	public static void Zero(RenderTexture field) {
		Scale(field, 0, field);
	}

	static Material plusMat;
	public static void Plus(Texture a, Texture b, RenderTexture output)
		=> Plus(a, b, 1, output);
	public static void Plus(Texture a, Texture b, float c, RenderTexture output) {
		if(!plusMat)
			plusMat = new Material(Shader.Find("ShaderFun/Field/Plus"));
		plusMat.SetTexture("A", a);
		plusMat.SetTexture("B", b);
		plusMat.SetFloat("C", c);
		if(output == a || output == b) {
			RenderTexture temp = RenderTexture.GetTemporary(output.width, output.height);
			Graphics.Blit(null, temp, plusMat);
			Graphics.Blit(temp, output);
			RenderTexture.ReleaseTemporary(temp);
		}
		else
			Graphics.Blit(null, output, plusMat);
	}

	static Material scaleMat;
	public static void Scale(Texture field, float scalar, RenderTexture output) {
		if(!scaleMat)
			scaleMat = new Material(Shader.Find("ShaderFun/Field/Scale"));
		scaleMat.SetTexture("Field", field);
		scaleMat.SetFloat("Scalar", scalar);
		if(output == field) {
			RenderTexture temp = RenderTexture.GetTemporary(output.width, output.height);
			Graphics.Blit(null, temp, scaleMat);
			Graphics.Blit(temp, output);
			RenderTexture.ReleaseTemporary(temp);
		}
		else
			Graphics.Blit(null, output, scaleMat);
	}
}