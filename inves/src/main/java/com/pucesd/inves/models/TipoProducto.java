package com.pucesd.inves.models;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

@Entity
@Table(name="ptipos")
@SuppressWarnings("serial")
public class TipoProducto implements Serializable {

	@Id
    @SequenceGenerator(name="ptipos_ptip_codi_seq",
         sequenceName="ptipos_ptip_codi_seq",
                       allocationSize=1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE,
                    generator="ptipos_ptip_codi_seq")
    @Column(name = "ptip_codi", updatable=false)
	private Integer codigo;
	
	@Column(name="ptip_nombre")
	private String nombre;

	public Integer getCodigo() {
		return codigo;
	}

	public void setCodigo(Integer codigo) {
		this.codigo = codigo;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	
	
}
