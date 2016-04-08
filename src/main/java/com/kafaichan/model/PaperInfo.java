package com.kafaichan.model;

/**
 * Created by kafaichan on 2016/4/2.
 */
public class PaperInfo {
    private String title;
    private String authors;
    private String conference;
    private int citenum;
    private String url;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getCitenum() {
        return citenum;
    }

    public void setCitenum(int citenum) {
        this.citenum = citenum;
    }

    public String getAuthors() {
        return authors;
    }

    public void setAuthors(String authors) {
        this.authors = authors;
    }

    public String getConference() {
        return conference;
    }

    public void setConference(String conference) {
        this.conference = conference;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
