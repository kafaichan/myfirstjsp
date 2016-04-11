package com.kafaichan.controller;

import com.kafaichan.model.PaperInfo;
import com.kafaichan.util.CypherUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


/**
 * Created by kafaichan on 2016/3/11.
 */

@Controller
public class HomeController {

    @RequestMapping(value="/helloworld",method= RequestMethod.POST)
    public ModelAndView home(String keyword) {
        HashMap<String, Object> hashMap = new HashMap<String,Object>();

        List<PaperInfo> paperList = new ArrayList<PaperInfo>();
        PaperInfo paperInfo = new PaperInfo();
        paperInfo.setTitle("Scalable Similarity Learning Using Large Margin Neighborhood Embedding");
        paperInfo.setAuthors("Zhaowen Wang, Jianchao Yang, Zhe Lin, Jonathan Brandt, Shiyu Chang, Thomas S. Huang");
        paperInfo.setConference("Applications of Computer Vision(2015)");
        paperInfo.setCitenum(1);
        paperInfo.setUrl("http://dx.doi.org/10.1109/WACV.2015.68");

        paperList.add(paperInfo);

        PaperInfo paperInfo2 = new PaperInfo();
        paperInfo2.setTitle("Decentralized Recommender Systems.");
        paperInfo2.setAuthors("Zhangyang Wang, Xianming Liu, Shiyu Chang, Jiayu Zhou, Guo-Jun Qi, Thomas S. Huang");
        paperInfo2.setConference("CoRR(2015)");
        paperInfo2.setCitenum(0);
        paperInfo2.setUrl("http://arxiv.org/abs/1503.01647");

        paperList.add(paperInfo2);

        paperList.add(paperInfo);
        paperList.add(paperInfo2);
        paperList.add(paperInfo2);
        paperList.add(paperInfo);

        hashMap.put("paperList", paperList);
        return new ModelAndView("helloworld", hashMap);
    }

    @RequestMapping(value="/ajax",method= RequestMethod.POST)
    @ResponseBody
    public String ajaxNeo4j(String keyword) throws IOException {

        System.out.println(keyword);

        CypherUtils utils = new CypherUtils();
        JSONObject obj = new JSONObject();
        JSONObject params = new JSONObject();

        try {
            params.put("author",keyword);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        try {
            obj.put("query","MATCH (x {name: {author}})-[r]-(paper) WHERE x.name = {author} RETURN r");
            obj.put("params",params);

        } catch (JSONException e) {
            e.printStackTrace();
        }
//        System.out.println(obj.toString());
        JSONObject respObject = null;

        try {
            respObject = utils.CypherHandler(obj);

            JSONArray jarray = (JSONArray)respObject.get("data");
            ParseRelationship(jarray);

        } catch (IOException e) {
            e.printStackTrace();
        }

        return respObject.toString();
    }


    private JSONObject ParseRelationship(JSONArray array){
        for(int i = 0; i < array.length(); ++i){
            JSONArray objectArray = (JSONArray)array.get(i);

            for(int j = 0; j < objectArray.length(); ++j){
                JSONObject obj = (JSONObject)objectArray.get(j);
                System.out.print(obj.toString(2));
                System.out.println();
            }
        }

        return null;
    }

    @RequestMapping(value="/testd3", method = RequestMethod.GET)
    public String testD3(){
        return "testd3";
    }


    @RequestMapping(value="/split", method=RequestMethod.GET)
    public String split(){
        return "result";
    }

}
