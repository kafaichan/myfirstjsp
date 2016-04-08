import com.kafaichan.util.CypherUtils;
import org.junit.Test;
import org.json.*;

import java.io.IOException;


/**
 * Created by kafaichan on 2016/3/12.
 */


public class TestGraphDB {
    @Test
    public void test() throws IOException {
        CypherUtils utils = new CypherUtils();

        JSONObject obj = new JSONObject();
        JSONObject params = new JSONObject();
        try {
            params.put("startName","JiaWei Han");
        } catch (JSONException e) {
            e.printStackTrace();
        }

        try {
            obj.put("query","MATCH (x {name: {startName}})-[r]-(paper) WHERE x.name = {startName} RETURN r");
            obj.put("params",params);

        } catch (JSONException e) {
            e.printStackTrace();
        }
        System.out.println(obj.toString());

        try {
            org.json.JSONObject respObject = utils.CypherHandler(obj);

            JSONArray jarray = (JSONArray)respObject.get("data");
            System.out.println(jarray.toString(2));

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
