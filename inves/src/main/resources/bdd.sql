-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.7.0
-- PostgreSQL version: 9.3
-- Project Site: pgmodeler.com.br
-- Model Author: ---

SET check_function_bodies = false;
-- ddl-end --


-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: "bdd_CC" | type: DATABASE --
-- -- DROP DATABASE "bdd_CC";
-- CREATE DATABASE "bdd_CC"
-- 	ENCODING = 'UTF8'
-- 	LC_COLLATE = 'Spanish_Spain.UTF8'
-- 	LC_CTYPE = 'Spanish_Spain.UTF8'
-- 	TABLESPACE = pg_default
-- 	OWNER = postgres
-- ;
-- -- ddl-end --
-- 

-- object: public.sp_consultar | type: FUNCTION --
-- DROP FUNCTION public.sp_consultar(IN character varying,IN character varying,IN character varying);
CREATE FUNCTION public.sp_consultar (IN opcion character varying, IN tipo character varying, IN busqueda character varying)
	RETURNS SETOF record
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	ROWS 1000
	AS $$

DECLARE
tabla record;
begin
 IF opcion = 'guardar' THEN

	alter sequence orden_tabla restart 1;
	for tabla in select nextval('orden_tabla') ,prod_codi ,prod_nomb ,prod_cant ,prod_pvp1 ,prod_fela ,prod_fcad ,prod_ubic from productos loop
	
    return next tabla;
end loop;
            
   
 END IF;  
  
return ;
end;
$$;
ALTER FUNCTION public.sp_consultar(IN character varying,IN character varying,IN character varying) OWNER TO postgres;
-- ddl-end --

-- object: public.sp_consultar_bodega | type: FUNCTION --
-- DROP FUNCTION public.sp_consultar_bodega(IN character varying,IN integer,IN character varying);
CREATE FUNCTION public.sp_consultar_bodega (IN opcion character varying, IN usu_bodega integer, IN busqueda character varying)
	RETURNS SETOF record
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	ROWS 1000
	AS $$

DECLARE
tabla record;
id_producto int[];
id_bodega int;
begin
 IF opcion = 'bodega' THEN
	for tabla in SELECT bode_codi, bode_nomb, bode_ubic FROM bodegas where usua_codi=usu_bodega loop
	
    return next tabla;
end loop;
            
   
 END IF;  


   IF opcion = 'productos' THEN
	select bode_codi into id_bodega from bodegas where bodegas.usua_codi= usu_bodega;
	for tabla in select bodeprods.prod_codi as codigo,productos.prod_nomb as nombre,productos.prod_cant as stock,prod_ubic
	from bodeprods,productos 
	where bode_codi=id_bodega and bodeprods.prod_codi=productos.prod_codi
 loop

    return next tabla;
end loop;
            
   
 END IF;
return ;
end;
$$;
ALTER FUNCTION public.sp_consultar_bodega(IN character varying,IN integer,IN character varying) OWNER TO postgres;
-- ddl-end --

-- object: public.sp_guardar_categoria | type: FUNCTION --
-- DROP FUNCTION public.sp_guardar_categoria(IN character varying,IN character varying,IN integer,IN character varying,IN character varying);
CREATE FUNCTION public.sp_guardar_categoria (IN tabla character varying, IN opcion character varying, IN id_categoria integer, IN nombre_categ character varying, IN tipo_categ character varying)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$

DECLARE
begin
	IF tabla = 'tproductos' THEN
		IF opcion = 'guardar' THEN

			INSERT INTO ptipos( ptip_nomb, ptip_cate)
				VALUES ( nombre_categ, tipo_categ);
		END IF;
	  
		IF opcion = 'modificar' THEN
			UPDATE ptipos SET 
			ptip_nomb=nombre_categ, 
			ptip_cate=tipo_categ
		WHERE ptip_codi=id_categoria;
	
		END IF;  
	END IF;

	IF tabla = 'tservicios' THEN
		IF opcion = 'guardar' THEN

			INSERT INTO stipos(stip_nomb, stip_cate)
				VALUES (nombre_categ, tipo_categ);

		END IF;
	  
		IF opcion = 'modificar' THEN
			UPDATE stipos SET 
			stip_nomb=nombre_categ, 
			stip_cate=tipo_categ
			WHERE stip_codi=id_categoria;

	
		END IF;  
	END IF;
  
return ;
end;
$$;
ALTER FUNCTION public.sp_guardar_categoria(IN character varying,IN character varying,IN integer,IN character varying,IN character varying) OWNER TO postgres;
-- ddl-end --

-- object: public.sp_guardar_compra | type: FUNCTION --
-- DROP FUNCTION public.sp_guardar_compra(IN character varying,IN character varying,IN integer,IN integer,IN character varying,IN character varying,IN integer,IN integer,IN integer,IN integer,IN integer);
CREATE FUNCTION public.sp_guardar_compra (IN tabla character varying, IN opcion character varying, IN id_compra integer, IN num_factura integer, IN fecha_elab character varying, IN fecha_pago character varying, IN estado_comp integer, IN usuario integer, IN proveedor integer, IN producto integer, IN cantidad integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$

DECLARE
num numeric;
id_compra int;
 id_bodega int;
begin

	IF tabla = 'productos' THEN
		 IF opcion = 'guardar' THEN

			id_compra=nextval('compras_comp_codi_seq'::regclass);
			INSERT INTO compras(comp_codi,comp_nfac, comp_fech, comp_fpag, comp_esta, usua_codi, prov_codi)
				VALUES (id_compra,num_factura, fecha_elab, fecha_pago,estado_comp, usuario,  proveedor);

			INSERT INTO comproductos(cpro_cant, prod_codi, comp_codi)
				VALUES (cantidad, producto, id_compra);

			    UPDATE productos SET 
				prod_cant=(prod_cant+cantidad) where prod_codi=producto;
			    

		   
		 END IF;  
	END IF;  

	IF tabla = 'servicios' THEN
		 IF opcion = 'guardar' THEN

			id_compra=nextval('compras_comp_codi_seq'::regclass);
			INSERT INTO compras(comp_codi,comp_nfac, comp_fech, comp_fpag, comp_esta, usua_codi, prov_codi)
				VALUES (id_compra,num_factura, fecha_elab, fecha_pago,estado_comp, usuario,  proveedor);

			INSERT INTO comservicios(cser_cant, serv_codi, comp_codi)
				VALUES (cantidad, producto, id_compra);
		   
		 END IF;  
	END IF;
return ;
end;
$$;
ALTER FUNCTION public.sp_guardar_compra(IN character varying,IN character varying,IN integer,IN integer,IN character varying,IN character varying,IN integer,IN integer,IN integer,IN integer,IN integer) OWNER TO postgres;
-- ddl-end --

-- object: public.sp_guardar_producto | type: FUNCTION --
-- DROP FUNCTION public.sp_guardar_producto(IN character varying,IN integer,IN character varying,IN integer,IN integer,IN integer,IN double precision,IN double precision,IN double precision,IN double precision,IN double precision,IN double precision,IN character varying,IN character varying,IN character varying,IN integer);
CREATE FUNCTION public.sp_guardar_producto (IN opcion character varying, IN id_producto integer, IN nombre_pro character varying, IN cantidad_pro integer, IN estado_pro integer, IN tipo_pro integer, IN precioc1 double precision, IN precioc2 double precision, IN preciov1 double precision, IN preciov2 double precision, IN preciov3 double precision, IN preciov4 double precision, IN fecha_elab character varying, IN fecha_caduc character varying, IN ubicacion_pro character varying, IN usuario integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$

DECLARE
num numeric;
id_pro int;
 id_bodega int;
begin
 IF opcion = 'guardar' THEN

	INSERT INTO productos(
            prod_nomb, prod_cant, prod_esta, ptip_codi, prod_pcp1, 
            prod_pcp2, prod_pvp1, prod_pvp2, prod_pvp3, prod_pvp4, prod_fela, 
            prod_fcad, prod_ubic) 
            values (nombre_pro,cantidad_pro,estado_pro,tipo_pro,precioc1,precioc2,preciov1,preciov2,preciov3,preciov4,fecha_elab,fecha_caduc,ubicacion_pro);
            
		select usuarios.bode_codi into id_bodega from bodegas,usuarios where usua_codi=usuario and bodegas.bode_codi=usuarios.bode_codi;
		select prod_codi into id_pro from productos where prod_nomb=nombre_pro;

         INSERT INTO bodeprods(
            prod_codi, bode_codi)   
            values(id_pro,id_bodega);
            
   
 END IF;  
IF opcion = 'modificar' THEN

	UPDATE productos SET  
	prod_nomb=nombre_pro, 
	prod_cant=cantidad_pro, 
	prod_esta=estado_pro, 
	prod_pcp1=precioc1, 
       prod_pcp2=precioc2, 
       prod_pvp1=preciov1, 
       prod_pvp2=preciov2, 
       prod_pvp3=preciov3,
       prod_pvp4=preciov4, 
       prod_fela=fecha_elab, 
       prod_fcad=fecha_caduc, 
       prod_ubic=ubicacion_pro, 
       ptip_codi=tipo_pro
 
	where prod_codi=id_producto;

		select usuarios.bode_codi into id_bodega from bodegas,usuarios where usua_codi=usuario and bodegas.bode_codi=usuarios.bode_codi;
		select prod_codi into id_pro from productos where prod_nomb=nombre_pro;   
   
 END IF;  
  
return ;
end;
$$;
ALTER FUNCTION public.sp_guardar_producto(IN character varying,IN integer,IN character varying,IN integer,IN integer,IN integer,IN double precision,IN double precision,IN double precision,IN double precision,IN double precision,IN double precision,IN character varying,IN character varying,IN character varying,IN integer) OWNER TO postgres;
-- ddl-end --

-- object: public.sp_guardar_venta | type: FUNCTION --
-- DROP FUNCTION public.sp_guardar_venta(IN character varying,IN integer,IN integer,IN integer,IN integer,IN double precision);
CREATE FUNCTION public.sp_guardar_venta (IN opcion character varying, IN id_ventaserv integer, IN id_servicio integer, IN id_venta integer, IN cantidad integer, IN precio double precision)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$

DECLARE
num numeric;
id_pro int;
 id_bodega int;
begin
		 IF opcion = 'guardarServ' THEN

			INSERT INTO venservicios(serv_codi, vent_codi, vser_cant, vser_prec)
				VALUES (id_servicio, id_venta, cantidad, precio);
				
		 END IF; 

		 IF opcion = 'guardarProd' THEN

			INSERT INTO venproductos(prod_codi, vent_codi, vpro_cant, vpro_prec)
				VALUES (id_servicio, id_venta, cantidad, precio);


			UPDATE productos SET 
				prod_cant=prod_cant-cantidad
			WHERE prod_codi=id_servicio;

				
		 END IF; 
  
return ;
end;
$$;
ALTER FUNCTION public.sp_guardar_venta(IN character varying,IN integer,IN integer,IN integer,IN integer,IN double precision) OWNER TO postgres;
-- ddl-end --

-- object: public.aseguradoras_aseg_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.aseguradoras_aseg_codi_seq;
CREATE SEQUENCE public.aseguradoras_aseg_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.aseguradoras_aseg_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.bodegas_bode_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.bodegas_bode_codi_seq;
CREATE SEQUENCE public.bodegas_bode_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.bodegas_bode_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.bodegas | type: TABLE --
-- DROP TABLE public.bodegas;
CREATE TABLE public.bodegas(
	bode_codi integer NOT NULL DEFAULT nextval('bodegas_bode_codi_seq'::regclass),
	bode_nomb character varying(20),
	bode_ubic character varying(20),
	CONSTRAINT pk_bode_codi PRIMARY KEY (bode_codi)

);
-- ddl-end --
ALTER TABLE public.bodegas OWNER TO postgres;
-- ddl-end --

-- object: public.bodeprods_bopr_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.bodeprods_bopr_codi_seq;
CREATE SEQUENCE public.bodeprods_bopr_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.bodeprods_bopr_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.bodeprods | type: TABLE --
-- DROP TABLE public.bodeprods;
CREATE TABLE public.bodeprods(
	bopr_codi integer NOT NULL DEFAULT nextval('bodeprods_bopr_codi_seq'::regclass),
	prod_codi integer NOT NULL,
	bode_codi integer NOT NULL,
	CONSTRAINT pk_bopr_codi PRIMARY KEY (bopr_codi)

);
-- ddl-end --
ALTER TABLE public.bodeprods OWNER TO postgres;
-- ddl-end --

-- object: public.clientes_cli_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.clientes_cli_codi_seq;
CREATE SEQUENCE public.clientes_cli_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.clientes_cli_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.clientes | type: TABLE --
-- DROP TABLE public.clientes;
CREATE TABLE public.clientes(
	cli_codi integer NOT NULL DEFAULT nextval('clientes_cli_codi_seq'::regclass),
	cli_cedu character varying(13),
	cli_nomb character varying(50),
	cli_apel character varying(50),
	cli_tipo integer,
	cli_esta integer,
	CONSTRAINT pk_cli_codi PRIMARY KEY (cli_codi)

);
-- ddl-end --
ALTER TABLE public.clientes OWNER TO postgres;
-- ddl-end --

-- object: public.compras_comp_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.compras_comp_codi_seq;
CREATE SEQUENCE public.compras_comp_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.compras_comp_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.compras | type: TABLE --
-- DROP TABLE public.compras;
CREATE TABLE public.compras(
	comp_codi integer NOT NULL DEFAULT nextval('compras_comp_codi_seq'::regclass),
	comp_fact integer NOT NULL,
	comp_fech character varying(20) NOT NULL,
	comp_fpag character varying(20) NOT NULL,
	comp_esta integer NOT NULL,
	usua_codi integer NOT NULL,
	comp_cur smallint,
	comp_tipo smallint,
	prov_codi integer NOT NULL,
	CONSTRAINT pk_comp_codi PRIMARY KEY (comp_codi)

);
-- ddl-end --
ALTER TABLE public.compras OWNER TO postgres;
-- ddl-end --

-- object: public.comproductos_cpro_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.comproductos_cpro_codi_seq;
CREATE SEQUENCE public.comproductos_cpro_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.comproductos_cpro_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.comproductos | type: TABLE --
-- DROP TABLE public.comproductos;
CREATE TABLE public.comproductos(
	cpro_codi integer NOT NULL DEFAULT nextval('comproductos_cpro_codi_seq'::regclass),
	cpro_cant integer NOT NULL,
	prod_codi integer NOT NULL,
	comp_codi integer NOT NULL,
	CONSTRAINT pk_cpro_codi PRIMARY KEY (cpro_codi)

);
-- ddl-end --
ALTER TABLE public.comproductos OWNER TO postgres;
-- ddl-end --

-- object: public.comservicios_cser_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.comservicios_cser_codi_seq;
CREATE SEQUENCE public.comservicios_cser_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.comservicios_cser_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.descuentos_desc_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.descuentos_desc_codi_seq;
CREATE SEQUENCE public.descuentos_desc_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.descuentos_desc_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.empresas_empr_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.empresas_empr_codi_seq;
CREATE SEQUENCE public.empresas_empr_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.empresas_empr_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.facturas_fact_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.facturas_fact_codi_seq;
CREATE SEQUENCE public.facturas_fact_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.facturas_fact_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.grupos_grup_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.grupos_grup_codi_seq;
CREATE SEQUENCE public.grupos_grup_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.grupos_grup_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.orden_tabla | type: SEQUENCE --
-- DROP SEQUENCE public.orden_tabla;
CREATE SEQUENCE public.orden_tabla
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9999999999999999
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.orden_tabla OWNER TO postgres;
-- ddl-end --

-- object: public.parametros_parm_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.parametros_parm_codi_seq;
CREATE SEQUENCE public.parametros_parm_codi_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.parametros_parm_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.productos_prod_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.productos_prod_codi_seq;
CREATE SEQUENCE public.productos_prod_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.productos_prod_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.productos | type: TABLE --
-- DROP TABLE public.productos;
CREATE TABLE public.productos(
	prod_codi integer NOT NULL DEFAULT nextval('productos_prod_codi_seq'::regclass),
	prod_nomb character varying(40),
	prod_cant integer,
	prod_pcp numeric(10,2),
	prod_fela character varying(20),
	prod_fcad character varying(20),
	prod_ubic character varying(20),
	prod_esta integer,
	tipo_producto smallint NOT NULL,
	CONSTRAINT pk_prod_codi PRIMARY KEY (prod_codi)

);
-- ddl-end --
ALTER TABLE public.productos OWNER TO postgres;
-- ddl-end --

-- object: public.proveedores_prov_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.proveedores_prov_codi_seq;
CREATE SEQUENCE public.proveedores_prov_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.proveedores_prov_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.proveedores | type: TABLE --
-- DROP TABLE public.proveedores;
CREATE TABLE public.proveedores(
	prov_codi integer NOT NULL DEFAULT nextval('proveedores_prov_codi_seq'::regclass),
	prov_ruc character varying(13),
	prov_nomb character varying(80),
	prov_dire character varying(80),
	prov_tel1 character varying(12),
	prov_cor1 character varying(40),
	prov_sucu character varying(50),
	prov_esta integer,
	CONSTRAINT pk_prov_codi PRIMARY KEY (prov_codi)

);
-- ddl-end --
ALTER TABLE public.proveedores OWNER TO postgres;
-- ddl-end --

-- object: public.ptipos_ptip_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.ptipos_ptip_codi_seq;
CREATE SEQUENCE public.ptipos_ptip_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.ptipos_ptip_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.servicios_serv_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.servicios_serv_codi_seq;
CREATE SEQUENCE public.servicios_serv_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.servicios_serv_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.stipos_stip_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.stipos_stip_codi_seq;
CREATE SEQUENCE public.stipos_stip_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.stipos_stip_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.subgrupos_sgru_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.subgrupos_sgru_codi_seq;
CREATE SEQUENCE public.subgrupos_sgru_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.subgrupos_sgru_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.usuarios_usua_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.usuarios_usua_codi_seq;
CREATE SEQUENCE public.usuarios_usua_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.usuarios_usua_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.usuarios | type: TABLE --
-- DROP TABLE public.usuarios;
CREATE TABLE public.usuarios(
	usua_codi integer NOT NULL DEFAULT nextval('usuarios_usua_codi_seq'::regclass),
	usua_login character varying(15),
	usua_pass character varying(15),
	usua_nombre character varying(60),
	usua_tipo integer,
	usua_esta integer NOT NULL,
	bode_codi integer DEFAULT 0,
	CONSTRAINT pk_usua_codi PRIMARY KEY (usua_codi)

);
-- ddl-end --
ALTER TABLE public.usuarios OWNER TO postgres;
-- ddl-end --

-- object: public.ventas_vent_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.ventas_vent_codi_seq;
CREATE SEQUENCE public.ventas_vent_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.ventas_vent_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.venproductos_vpro_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.venproductos_vpro_codi_seq;
CREATE SEQUENCE public.venproductos_vpro_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.venproductos_vpro_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.pedidosproductos | type: TABLE --
-- DROP TABLE public.pedidosproductos;
CREATE TABLE public.pedidosproductos(
	pedipro_codi integer NOT NULL DEFAULT nextval('venproductos_vpro_codi_seq'::regclass),
	pedipro_cant integer NOT NULL,
	prod_codi integer NOT NULL,
	pedi_codi integer NOT NULL,
	CONSTRAINT pk_vpro_codi PRIMARY KEY (pedipro_codi)

);
-- ddl-end --
ALTER TABLE public.pedidosproductos OWNER TO postgres;
-- ddl-end --

-- object: public.venservicios_vser_codi_seq | type: SEQUENCE --
-- DROP SEQUENCE public.venservicios_vser_codi_seq;
CREATE SEQUENCE public.venservicios_vser_codi_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
ALTER SEQUENCE public.venservicios_vser_codi_seq OWNER TO postgres;
-- ddl-end --

-- object: public.pedidos | type: TABLE --
-- DROP TABLE public.pedidos;
CREATE TABLE public.pedidos(
	pedi_codi integer NOT NULL DEFAULT nextval('ventas_vent_codi_seq'::regclass),
	pedi_fdev character varying(20),
	pedi_fentre character varying(20),
	pedi_clie integer NOT NULL,
	usua_codi integer NOT NULL,
	pedi_esta integer NOT NULL,
	CONSTRAINT pk_vent_codi PRIMARY KEY (pedi_codi)

);
-- ddl-end --
COMMENT ON COLUMN public.pedidos.pedi_fdev IS 'fecha de devolucion del bien';
COMMENT ON COLUMN public.pedidos.pedi_fentre IS 'fecha de entrega del bien';
ALTER TABLE public.pedidos OWNER TO postgres;
-- ddl-end --

-- object: public.sp_guardar_cliente | type: FUNCTION --
-- DROP FUNCTION public.sp_guardar_cliente(IN integer,IN integer,IN integer,IN character varying,IN character varying,IN character varying,IN character varying,IN character varying,IN character varying,IN character varying,IN integer,IN integer);
CREATE FUNCTION public.sp_guardar_cliente (IN opcion integer, IN id integer, IN ruc integer, IN nombres character varying, IN apellidos character varying, IN telefono1 character varying, IN telefono2 character varying, IN correo1 character varying, IN correo2 character varying, IN direccion character varying, IN tipo integer, IN aseguradora integer)
	RETURNS integer
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$

begin	

	if(opcion = 0)then
	
		INSERT INTO clientes(cli_apel, cli_nomb, cli_ruc, cli_tipo, cli_cor1, cli_cor2, 
		    cli_tel1, cli_tel2, cli_dire, cli_esta, sgru_codi)
		values(apellidos,nombres,ruc,tipo,correo1,correo2,telefono1,telefono2,direccion,1,aseguradora);

		return 1;
	end if;

	if(opcion = 1)then
		
		UPDATE clientes SET 
			cli_apel=apellidos, 
			cli_nomb=nombres, 
			cli_ruc=ruc, 
			cli_tipo=tipo, 
			cli_cor1=correo1, 
			cli_cor2=correo2, 
			cli_tel1=telefono1, 
			cli_tel2=telefono1, 
			cli_dire=direccion, 
			sgru_codi=aseguradora
		WHERE cli_codi=codigo;


		return 1;
	end if;

		
	
end;
$$;
ALTER FUNCTION public.sp_guardar_cliente(IN integer,IN integer,IN integer,IN character varying,IN character varying,IN character varying,IN character varying,IN character varying,IN character varying,IN character varying,IN integer,IN integer) OWNER TO postgres;
-- ddl-end --

-- object: public.sp_contar_registros | type: FUNCTION --
-- DROP FUNCTION public.sp_contar_registros(IN character varying,IN character varying);
CREATE FUNCTION public.sp_contar_registros (IN tabla character varying, IN consulta character varying)
	RETURNS integer
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$

DECLARE
registros integer;
begin
registros:=-1;
	 IF tabla = 'aseguradoras' THEN
			select count(*) into registros from clientes where (cli_ruc=consulta and cli_esta=1);
	 END IF;

return registros;
end;
$$;
ALTER FUNCTION public.sp_contar_registros(IN character varying,IN character varying) OWNER TO postgres;
-- ddl-end --

-- object: public.sp_eliminar | type: FUNCTION --
-- DROP FUNCTION public.sp_eliminar(IN character varying,IN integer);
CREATE FUNCTION public.sp_eliminar (IN tabla character varying, IN id integer)
	RETURNS integer
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$

begin	

	if(tabla = 'clientes')then
		delete from clientes where cli_codi=id;
		return 1;
	end if;	
	
end;
$$;
ALTER FUNCTION public.sp_eliminar(IN character varying,IN integer) OWNER TO postgres;
-- ddl-end --

-- object: public.ptipos | type: TABLE --
-- DROP TABLE public.ptipos;
CREATE TABLE public.ptipos(
	ptip_codi serial NOT NULL,
	ptip_nombre character varying(50) NOT NULL,
	CONSTRAINT pk_ptipos PRIMARY KEY (ptip_codi)

);
-- ddl-end --
-- object: bodega_bodeprod_fk | type: CONSTRAINT --
-- ALTER TABLE public.bodeprods DROP CONSTRAINT bodega_bodeprod_fk;
ALTER TABLE public.bodeprods ADD CONSTRAINT bodega_bodeprod_fk FOREIGN KEY (bode_codi)
REFERENCES public.bodegas (bode_codi) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: producto_bodeprod_fk | type: CONSTRAINT --
-- ALTER TABLE public.bodeprods DROP CONSTRAINT producto_bodeprod_fk;
ALTER TABLE public.bodeprods ADD CONSTRAINT producto_bodeprod_fk FOREIGN KEY (prod_codi)
REFERENCES public.productos (prod_codi) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: proveedores_compras_fk | type: CONSTRAINT --
-- ALTER TABLE public.compras DROP CONSTRAINT proveedores_compras_fk;
ALTER TABLE public.compras ADD CONSTRAINT proveedores_compras_fk FOREIGN KEY (prov_codi)
REFERENCES public.proveedores (prov_codi) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: compras_comproductos_fk | type: CONSTRAINT --
-- ALTER TABLE public.comproductos DROP CONSTRAINT compras_comproductos_fk;
ALTER TABLE public.comproductos ADD CONSTRAINT compras_comproductos_fk FOREIGN KEY (comp_codi)
REFERENCES public.compras (comp_codi) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: producto_compra_fk | type: CONSTRAINT --
-- ALTER TABLE public.comproductos DROP CONSTRAINT producto_compra_fk;
ALTER TABLE public.comproductos ADD CONSTRAINT producto_compra_fk FOREIGN KEY (prod_codi)
REFERENCES public.productos (prod_codi) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_tipos_productos | type: CONSTRAINT --
-- ALTER TABLE public.productos DROP CONSTRAINT fk_tipos_productos;
ALTER TABLE public.productos ADD CONSTRAINT fk_tipos_productos FOREIGN KEY (tipo_producto)
REFERENCES public.ptipos (ptip_codi) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: producto_venprod_fk | type: CONSTRAINT --
-- ALTER TABLE public.pedidosproductos DROP CONSTRAINT producto_venprod_fk;
ALTER TABLE public.pedidosproductos ADD CONSTRAINT producto_venprod_fk FOREIGN KEY (prod_codi)
REFERENCES public.productos (prod_codi) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: venta_venprod_fk | type: CONSTRAINT --
-- ALTER TABLE public.pedidosproductos DROP CONSTRAINT venta_venprod_fk;
ALTER TABLE public.pedidosproductos ADD CONSTRAINT venta_venprod_fk FOREIGN KEY (pedi_codi)
REFERENCES public.pedidos (pedi_codi) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_clientes | type: CONSTRAINT --
-- ALTER TABLE public.pedidos DROP CONSTRAINT fk_clientes;
ALTER TABLE public.pedidos ADD CONSTRAINT fk_clientes FOREIGN KEY (pedi_clie)
REFERENCES public.clientes (cli_codi) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- object: fk_usuarios | type: CONSTRAINT --
-- ALTER TABLE public.pedidos DROP CONSTRAINT fk_usuarios;
ALTER TABLE public.pedidos ADD CONSTRAINT fk_usuarios FOREIGN KEY (usua_codi)
REFERENCES public.usuarios (usua_codi) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --



