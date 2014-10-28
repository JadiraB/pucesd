package com.pucesd.inves.actions;

import com.opensymphony.xwork2.Action;
import com.opensymphony.xwork2.ActionSupport;
import com.pucesd.inves.models.TipoProducto;
import com.pucesd.inves.repos.TipoProductoRepository;

import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.beans.factory.annotation.Autowired;

@Results({
        @Result(name = Action.SUCCESS, location = "${redirectName}", type = "redirectAction")
})
public class Index extends ActionSupport {

	@Autowired
	private TipoProductoRepository repo; 
	
    private String redirectName;

    public String execute() {
    	
    	Iterable<TipoProducto> tipos = repo.findAll();
    	for (TipoProducto tipoProducto : tipos) {
			System.out.println(tipoProducto);
		}
    	
        redirectName = "hello";
        return Action.SUCCESS;
    }

    public String getRedirectName() {
        return redirectName;
    }

}
