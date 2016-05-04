using UnityEngine;
using System.Collections;
using System.Linq;
using System.Runtime.InteropServices;

public class DrawProseduralOnRenderObject : MonoBehaviour
{
    public Mesh mesh;
    public Material material;
    public int numInstances;

    ComputeBuffer verticesBuffer;

    void Start()
    {
        var verts = mesh.triangles.Select(i => mesh.vertices[i]).ToArray();
        verticesBuffer = new ComputeBuffer(mesh.triangles.Length, Marshal.SizeOf(typeof(Vector3)));
        verticesBuffer.SetData(verts);
        material = Instantiate<Material>(material);
        material.SetBuffer("_Vertices", verticesBuffer);
    }

    void OnRenderObject()
    {
        material.SetPass(0);
        Graphics.DrawProcedural(MeshTopology.Triangles, mesh.triangles.Length, numInstances);
    }

    void OnDestroy()
    {
        verticesBuffer.Release();
    }
}
