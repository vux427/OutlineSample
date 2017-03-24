using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutlinePostProcess : MonoBehaviour {

    public Color outlineColor = Color.black;
    Camera postProcessCam,renderCam;
    Material postMat;

    void Start()
    {
        postProcessCam = GetComponent<Camera>();
        postMat = new Material(Shader.Find("Hide/OutlinePostprocess"));

        //set up temp camera
        renderCam = new GameObject().AddComponent<Camera>();
        renderCam.transform.SetParent(postProcessCam.transform);
        renderCam.gameObject.name = "OutlineRenderCamera";
        renderCam.enabled = false;
        renderCam.CopyFrom(postProcessCam);
        renderCam.clearFlags = CameraClearFlags.Color;
        renderCam.backgroundColor = Color.black;
        renderCam.renderingPath = RenderingPath.Forward;

        //cull any layer that isn't the outline
        renderCam.cullingMask = 1 << LayerMask.NameToLayer("Outline");
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {

        postMat.SetColor("_OutlineColor", outlineColor);

        //make rendertexture
        RenderTexture rt = new RenderTexture(source.width, source.height, 0, RenderTextureFormat.R8);
        rt.Create();
        renderCam.targetTexture = rt;
        renderCam.RenderWithShader(Shader.Find("Hide/SimpleColor"),"");
        Graphics.Blit(rt, destination, postMat);
        rt.Release();
    }
}
