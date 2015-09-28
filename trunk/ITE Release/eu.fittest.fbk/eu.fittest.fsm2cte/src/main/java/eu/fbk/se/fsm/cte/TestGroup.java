//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vhudson-jaxb-ri-2.1-833 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2014.02.10 at 12:49:15 PM CET 
//


package eu.fbk.se.fsm.cte;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElements;
import javax.xml.bind.annotation.XmlID;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.CollapsedStringAdapter;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;


/**
 * <p>Java class for anonymous complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;choice maxOccurs="unbounded" minOccurs="0">
 *           &lt;element ref="{}TestGroup"/>
 *           &lt;element name="TestCase">
 *             &lt;complexType>
 *               &lt;complexContent>
 *                 &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                   &lt;sequence>
 *                     &lt;choice maxOccurs="unbounded" minOccurs="0">
 *                       &lt;element ref="{}Mark"/>
 *                     &lt;/choice>
 *                     &lt;choice maxOccurs="unbounded" minOccurs="0">
 *                       &lt;element ref="{}Marks"/>
 *                     &lt;/choice>
 *                     &lt;group ref="{}tagGroup" maxOccurs="unbounded" minOccurs="0"/>
 *                   &lt;/sequence>
 *                   &lt;attGroup ref="{}validityGroup"/>
 *                   &lt;attGroup ref="{}nameIDattrRequireName"/>
 *                   &lt;attGroup ref="{}styleGroup"/>
 *                 &lt;/restriction>
 *               &lt;/complexContent>
 *             &lt;/complexType>
 *           &lt;/element>
 *           &lt;element ref="{}TestSequence"/>
 *         &lt;/choice>
 *         &lt;group ref="{}tagGroup" maxOccurs="unbounded" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attGroup ref="{}nameIDattrRequireName"/>
 *       &lt;attGroup ref="{}styleGroup"/>
 *       &lt;attGroup ref="{}validityGroup"/>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "testGroupOrTestCaseOrTestSequence",
    "tagGroup"
})
@XmlRootElement(name = "TestGroup")
public class TestGroup {

    @XmlElements({
        @XmlElement(name = "TestSequence", type = TestSequence.class),
        @XmlElement(name = "TestCase", type = TestGroup.TestCase.class),
        @XmlElement(name = "TestGroup", type = TestGroup.class)
    })
    protected List<Object> testGroupOrTestCaseOrTestSequence;
    @XmlElement(name = "Tag")
    protected List<Mark.Tag> tagGroup;
    @XmlAttribute(required = true)
    @XmlJavaTypeAdapter(CollapsedStringAdapter.class)
    @XmlID
    protected String id;
    @XmlAttribute(required = true)
    protected String name;
    @XmlAttribute
    protected String style;
    @XmlAttribute
    protected Validity validity;

    /**
     * Gets the value of the testGroupOrTestCaseOrTestSequence property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the testGroupOrTestCaseOrTestSequence property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getTestGroupOrTestCaseOrTestSequence().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link TestSequence }
     * {@link TestGroup.TestCase }
     * {@link TestGroup }
     * 
     * 
     */
    public List<Object> getTestGroupOrTestCaseOrTestSequence() {
        if (testGroupOrTestCaseOrTestSequence == null) {
            testGroupOrTestCaseOrTestSequence = new ArrayList<Object>();
        }
        return this.testGroupOrTestCaseOrTestSequence;
    }

    /**
     * Gets the value of the tagGroup property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the tagGroup property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getTagGroup().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Mark.Tag }
     * 
     * 
     */
    public List<Mark.Tag> getTagGroup() {
        if (tagGroup == null) {
            tagGroup = new ArrayList<Mark.Tag>();
        }
        return this.tagGroup;
    }

    /**
     * Gets the value of the id property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getId() {
        return id;
    }

    /**
     * Sets the value of the id property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setId(String value) {
        this.id = value;
    }

    /**
     * Gets the value of the name property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the value of the name property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setName(String value) {
        this.name = value;
    }

    /**
     * Gets the value of the style property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStyle() {
        return style;
    }

    /**
     * Sets the value of the style property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStyle(String value) {
        this.style = value;
    }

    /**
     * Gets the value of the validity property.
     * 
     * @return
     *     possible object is
     *     {@link Validity }
     *     
     */
    public Validity getValidity() {
        return validity;
    }

    /**
     * Sets the value of the validity property.
     * 
     * @param value
     *     allowed object is
     *     {@link Validity }
     *     
     */
    public void setValidity(Validity value) {
        this.validity = value;
    }


    /**
     * <p>Java class for anonymous complex type.
     * 
     * <p>The following schema fragment specifies the expected content contained within this class.
     * 
     * <pre>
     * &lt;complexType>
     *   &lt;complexContent>
     *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *       &lt;sequence>
     *         &lt;choice maxOccurs="unbounded" minOccurs="0">
     *           &lt;element ref="{}Mark"/>
     *         &lt;/choice>
     *         &lt;choice maxOccurs="unbounded" minOccurs="0">
     *           &lt;element ref="{}Marks"/>
     *         &lt;/choice>
     *         &lt;group ref="{}tagGroup" maxOccurs="unbounded" minOccurs="0"/>
     *       &lt;/sequence>
     *       &lt;attGroup ref="{}validityGroup"/>
     *       &lt;attGroup ref="{}nameIDattrRequireName"/>
     *       &lt;attGroup ref="{}styleGroup"/>
     *     &lt;/restriction>
     *   &lt;/complexContent>
     * &lt;/complexType>
     * </pre>
     * 
     * 
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
        "mark",
        "marks",
        "tagGroup"
    })
    public static class TestCase {

        @XmlElement(name = "Mark")
        protected List<Mark> mark;
        @XmlElement(name = "Marks")
        protected List<Marks> marks;
        @XmlElement(name = "Tag")
        protected List<Mark.Tag> tagGroup;
        @XmlAttribute
        protected Validity validity;
        @XmlAttribute(required = true)
        @XmlJavaTypeAdapter(CollapsedStringAdapter.class)
        @XmlID
        protected String id;
        @XmlAttribute(required = true)
        protected String name;
        @XmlAttribute
        protected String style;

        /**
         * Gets the value of the mark property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the mark property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getMark().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link Mark }
         * 
         * 
         */
        public List<Mark> getMark() {
            if (mark == null) {
                mark = new ArrayList<Mark>();
            }
            return this.mark;
        }

        /**
         * Gets the value of the marks property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the marks property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getMarks().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link Marks }
         * 
         * 
         */
        public List<Marks> getMarks() {
            if (marks == null) {
                marks = new ArrayList<Marks>();
            }
            return this.marks;
        }

        /**
         * Gets the value of the tagGroup property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the tagGroup property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getTagGroup().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link Mark.Tag }
         * 
         * 
         */
        public List<Mark.Tag> getTagGroup() {
            if (tagGroup == null) {
                tagGroup = new ArrayList<Mark.Tag>();
            }
            return this.tagGroup;
        }

        /**
         * Gets the value of the validity property.
         * 
         * @return
         *     possible object is
         *     {@link Validity }
         *     
         */
        public Validity getValidity() {
            return validity;
        }

        /**
         * Sets the value of the validity property.
         * 
         * @param value
         *     allowed object is
         *     {@link Validity }
         *     
         */
        public void setValidity(Validity value) {
            this.validity = value;
        }

        /**
         * Gets the value of the id property.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getId() {
            return id;
        }

        /**
         * Sets the value of the id property.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setId(String value) {
            this.id = value;
        }

        /**
         * Gets the value of the name property.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getName() {
            return name;
        }

        /**
         * Sets the value of the name property.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setName(String value) {
            this.name = value;
        }

        /**
         * Gets the value of the style property.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getStyle() {
            return style;
        }

        /**
         * Sets the value of the style property.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setStyle(String value) {
            this.style = value;
        }

    }

}
