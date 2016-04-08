package com.kafaichan.util;


import com.sun.jersey.core.util.Base64;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;



public class CypherUtils {
    private static final String BaseURL = "http://localhost:7474/";
    private static final String CreateNodeURL = BaseURL + "db/data/node";
    private static final String CypherURL = BaseURL + "db/data/cypher";
    private static final String BatchURL = BaseURL + "/db/data/batch";


    private static HttpClient client = null;
    public CypherUtils(){
        client = new DefaultHttpClient();
    }

    private String parseResponseString(InputStream inputStream){
        StringBuilder result = new StringBuilder();

        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
        String line;

        try {
            while((line = reader.readLine()) != null){
                result.append(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result.toString();
    }

    public JSONObject CypherHandler(JSONObject obj) throws IOException {
        HttpPost postMethod = new HttpPost(CypherURL);

        postMethod.setHeader("Accept","application/json; charset=UTF-8");
        postMethod.setHeader("Content-Type","application/json");
        StringEntity entity = new StringEntity(obj.toString());

        // set authentication header
        postMethod.setEntity(entity);
        String encode = "Basic ";
        String payload = "neo4j:Pc28451342xx";
        byte[] b = Base64.encode(payload);
        postMethod.setHeader("Authorization", encode + new String(b, StandardCharsets.UTF_8));


        HttpResponse response = client.execute(postMethod);
        InputStream inputStream = response.getEntity().getContent();

        String respString = parseResponseString(inputStream);
        org.json.JSONObject respObject = new org.json.JSONObject(respString);

        return respObject;
    }

    public JSONObject getNodeInfo(String url) throws IOException {
        HttpGet getMethod = new HttpGet(url);

        HttpResponse response = client.execute(getMethod);
        InputStream inputStream = response.getEntity().getContent();

        String respString = parseResponseString(inputStream);
        JSONObject respObject = new JSONObject(respString);

        return respObject;
    }

    private JSONObject BatchOperations(JSONObject operations) throws IOException{
        HttpPost postMethod = new HttpPost(BatchURL);


        return null;
    }
}