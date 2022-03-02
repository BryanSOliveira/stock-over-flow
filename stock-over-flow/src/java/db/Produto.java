/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package db;

/**
 *
 * @author spbry
 */
public class Produto {
    private int id;
    private String name;
    private String material;
    private String size;
    private Marca brand;
    private Provider provider;
    private Movement value;
    private Movement availability;
    private Movement amount;
}