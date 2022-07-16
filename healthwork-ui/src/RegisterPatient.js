import React from "react";
//import loginImg from "../../login.svg";
import axios from 'axios';
import { Redirect } from 'react-router-dom';
import { components } from "react-select";
//import { default as ReactSelect } from "react-select";
import Multiselect from 'multiselect-react-dropdown';
import App from "./App";
import Select from "react-select";

//import Select from "react-select/dist/declarations/src/Select";


const Option = (props) => {
    return (
      <div>
        <components.Option {...props}>
          <input
            type="checkbox"
            checked={props.isSelected}
            onChange={() => null}
          />{" "}
          <label>{props.label}</label>
        </components.Option>
      </div>
    );
  };

  export const options = [
    { value: "Chest pain", label: "Chest pain" },
    { value: "Dizziness", label: "Dizziness" },
    { value: "Fainting", label: "Fainting" },
    { value: "Numbness", label: "Numbness" },
    { value: "Back pain", label: "Back pain" },
    { value: "Racing heartbeat", label: "Racing heartbeat" },
    { value: "Pale gray or blue skin color", label: "Pale gray or blue skin color" },
    { value: "Dry or persistent cough", label: "Dry or persistent cough" },
    { value: "Swelling", label: "Swelling" },
    { value: "Fatigue", label: "Fatigue" },
    { value: "Loss of appetite", label: "Loss of appetite" },
    { value: "lower back pain", label: "lower back pain" },
    { value: "head/neck/spine injuries", label: "head/neck/spine injuries" },
    { value: "Joint pain", label: "Joint pain" },
    { value: "Stiffness", label: "Stiffness" },
    { value: "head/neck/spine injuries", label: "head/neck/spine injuries" }
];

const styles = {
    multiValue: styles => {
      return {
        ...styles,
        backgroundColor: "papayawhip"
      };
    }
  };
export default class RegisterPatient extends React.Component {
  constructor(props) {
    super(props);
    this.state={
      key: '',
      name: '',
      age: '',
      symptoms: [],
      //specialization: '',
      //policies: [],
      redirect: false,
      adhar: '',
      email: '',
      password: '',
      organization: '',
      el:'',
      doctors:[],
      departments:[]
    }
  }
  onKeyChanged(e) { this.setState({ key: e.target.value.toUpperCase() }) }
  onNameChanged(e) { this.setState({ name: e.target.value }) }
  onAgeChanged(e) {this.setState({ age: e.target.value }) }
  onDiseaseChanged(e) { this.setState({ disease: e.target.value }) }
  onemergencylevelChanged(e) { this.setState({ el: e.target.value }) }
  onadharChanged(e) {this.setState({adhar: e.target.value})}
  onemailchanged(e) {this.setState({email: e.target.value})}
  onpasswordchanged(e) {this.setState({password: e.target.value})}
  onorganizationchanged(e) {this.setState({organization: e.target.value})}
//   onsymptomschanged(e) {
//     this.state.symptoms.push(e.target.value);
//     // this.setState({
//     //     symptoms: symptoms
//     // })
// }

  onFormSubmit(e) {
    e.preventDefault();

    // if(this.handleValidation())
    // {
        this.props.setLoading(true);
        //console.log(this.state.policies);
        axios.post('http://'+  process.env.REACT_APP_API_HOST  +':'+ process.env.REACT_APP_API_PORT+'/patients', {
            key: this.state.key,
            name: this.state.name,
            age: this.state.age,
            disease: this.state.disease,
            specialization: this.state.specialization,
            email: this.state.email,
            adhar: this.state.adhar,
            password : this.state.password,
            symptoms: this.state.symptoms,
            doctors: this.state.doctors, 
            departments: this.state.departments
            //policies: this.state.policies
        }).then(res => {
            this.props.setLoading(false);
            this.props.setHidden(true);
            if (res.data.status) {
                alert(res.data.message);
                this.setState({redirect: true })
            } else {
                alert(res.data.error.message)
            }
        }).catch(err => {
            this.props.setLoading(false);
            this.props.setHidden(true);
            alert('Something went wrong')
        });
        console.log(1);
    // }
    // else
    // {
    //     alert('form has errors');
    // }
    }

    onSelect(selectedList, selectedItem) {
        selectedItem.value.forEach(element => {
            this.state.symptoms.push(element);
        });
        axios.get('http://'+  process.env.REACT_APP_API_HOST  +':'+ process.env.REACT_APP_API_PORT+'/doctors/'+selectedList, {
        }).then(res => {
            this.props.setLoading(false);
            this.setState({doctors: []})
            if (res.data.status) {
                alert(res.data.message);
                this.setState({doctors: res.data})
                this.state.doctors.forEach(doctor=>{
                    this.doctors.push(doctor.Specialization)
                })
                window.location.reload();
            } else {
                alert(res.data.error.message)
            }
        }).catch(err => {
            this.props.setLoading(false);
            alert('Something went wrong')
        });
    }
    
    onRemove(selectedList, removedItem) {
        removedItem.value.forEach(element => {
            this.state.symptoms.pop(element);
        });
        axios.get('http://'+  process.env.REACT_APP_API_HOST  +':'+ process.env.REACT_APP_API_PORT+'/doctors/'+selectedList, {
        }).then(res => {
            this.props.setLoading(false);
            this.setState({doctors: []})
            if (res.data.status) {
                alert(res.data.message);
                this.setState({doctors: res.data})
                window.location.reload();
            } else {
                alert(res.data.error.message)
            }
        }).catch(err => {
            this.props.setLoading(false);
            alert('Something went wrong')
        });
    }
  
componentDidUpdate(prevProps, prevState,snapshot){
    if(this.state.email !== prevState.email)
    {
        this.setState({key: prevState.key})
        this.setState({email: prevState.email})
        this.setState({name: prevState.name})
        this.setState({age: prevState.age})
        this.setState({redirect: prevState.redirect})
        this.setState({password: prevState.password})
        this.setState({organization: prevState.organization})
        this.setState({el: prevState.el})
    }
}

  render() {
    if (this.state.redirect) {
      return <Redirect  to={{pathname:'/view-patient-info/' + this.state.email, state:{password: this.state.password}}}/>
  }

  if(this.state.doctors.length > 0){
    return(
        <div className="row">
        <form className="col s12" onSubmit={this.onFormSubmit.bind(this)}>
            
        <div className="row">
                <div className="input-field col s12">
                    <input id="email" type="text" className="validate" required value={this.state.email} onChange={this.onemailchanged.bind(this)} />
                    <label htmlFor="email">Email (e.g. abc@example.com)</label>
                </div>
            </div>
            <div className="row">
                <div className="input-field col s12">
                    <input id="password" type="password" className="validate" required value={this.state.password} onChange={this.onpasswordchanged.bind(this)} />
                    <label htmlFor="password">Password </label>
                </div>
            </div>
            <div className="row">
                <div className="input-field col s12">
                    <input id="key" type="text" className="validate" required value={this.state.key} onChange={this.onKeyChanged.bind(this)} />
                    <label htmlFor="key">Patient Number (e.g. Patient102)</label>
                </div>
            </div>
            <div className="row">
                <div className="input-field col s12">
                    <input id="adhar" type="text" className="validate" required value={this.state.adhar} onChange={this.onadharChanged.bind(this)} />
                    <label htmlFor="adhar">Aadhar Number </label>
                </div>
            </div>
            <div className="row">
                <div className="input-field col s4">
                    <input id="name" type="text" required className="validate" required value={this.state.name} onChange={this.onNameChanged.bind(this)} />
                    <label htmlFor="name">Name (e.g. Lexus)</label>
                </div>
                <div className="input-field col s4">
                    <input id="age" type="text" required className="validate"  required value={this.state.age} onChange={this.onAgeChanged.bind(this)}  />
                    <label htmlFor="age">Age (e.g. 20)</label>
                </div>
                <div className="input-field col s4">
                    <select style={{border: "1px solid rgb(0, 0, 0)"}} className="browser-default" required value={this.state.el} onChange={this.onemergencylevelChanged.bind(this)}>
                        <option value="" disabled>Select Emergency Level</option>
                        <option>Low</option>
                        <option>High</option>
                        {/* <option>Dermatology</option>
                        <option>Pediatrics</option>
                        <option>Radiology</option> */}
                    </select>
                </div>
            </div>
            <div className="row">
                   <Select
                   styles={styles}
                   closeMenuOnSelect={false}
                   onSelect={this.onSelect} // Function will trigger on select event
  onRemove={this.onRemove}
  options={options} 
  displayValue="value" 
  placeholder="Please select the symptoms"
  maxMenuHeight={100} 
  isMulti
            />
        <br></br>
        <br></br>
        <br></br>
        <br></br>
        <br></br>
            </div>       
        </form>

        <div className="col s12">
        <table className='striped responsive-table'>
            <tbody>
            <th style={{border: "3px solid rgb(0, 0, 0)",width: '33.33%', textAlign: 'center'}}>Doctor Name</th>
            <th style={{border: "3px solid rgb(0, 0, 0)",width: '33.33%', textAlign: 'center'}}>Speciality</th>
            <th style={{border: "3px solid rgb(0, 0, 0)",width: '33.33%', textAlign: 'center'}}>Organization</th>
            {/* <tr>
                return(            {this.state.doctors.forEach(doctor => { 
                                          <td style={{textAlign: 'center',border: "3px solid rgb(0, 0, 0)"}}>{doctor.Name}</td>
                                          <td style={{border: "3px solid rgb(0, 0, 0)",textAlign: 'center'}}>{doctor.Speciality}</td>
                                          <td style={{border: "3px solid rgb(0, 0, 0)",textAlign: 'center'}}>{doctor.Specialization}</td>                                                                                           
              
              })};)
            </tr>                         */}
              {this.state.doctors.map(( listValue, index ) => {
          return (
            <tr key={index}>
              <td>{listValue.id}</td>
              <td>{listValue.title}</td>
              <td>{listValue.price}</td>
            </tr>
          );
        })}
            </tbody>
        </table>
        </div>
        <div className="row">
          <div className="input-field col s12">
          <button className="btn waves-effect waves-light light-blue darken-3" type="submit" name="action">Submit
                        <i className="material-icons right">send</i>
         </button>
          </div>
        </div>
    </div>

    )
}else{
    return ( 
        <div className="row">
        <form className="col s12" onSubmit={this.onFormSubmit.bind(this)}>
            
        <div className="row">
                <div className="input-field col s12">
                    <input id="email" type="text" className="validate" required value={this.state.email} onChange={this.onemailchanged.bind(this)} />
                    <label htmlFor="email">Email (e.g. abc@example.com)</label>
                </div>
            </div>
            <div className="row">
                <div className="input-field col s12">
                    <input id="password" type="password" className="validate" required value={this.state.password} onChange={this.onpasswordchanged.bind(this)} />
                    <label htmlFor="password">Password </label>
                </div>
            </div>
            <div className="row">
                <div className="input-field col s12">
                    <input id="key" type="text" className="validate" required value={this.state.key} onChange={this.onKeyChanged.bind(this)} />
                    <label htmlFor="key">Patient Number (e.g. Patient102)</label>
                </div>
            </div>
            <div className="row">
                <div className="input-field col s12">
                    <input id="adhar" type="text" className="validate" required value={this.state.adhar} onChange={this.onadharChanged.bind(this)} />
                    <label htmlFor="adhar">Aadhar Number </label>
                </div>
            </div>
            <div className="row">
                <div className="input-field col s4">
                    <input id="name" type="text" required className="validate" required value={this.state.name} onChange={this.onNameChanged.bind(this)} />
                    <label htmlFor="name">Name (e.g. Lexus)</label>
                </div>
                <div className="input-field col s4">
                    <input id="age" type="text" required className="validate"  required value={this.state.age} onChange={this.onAgeChanged.bind(this)}  />
                    <label htmlFor="age">Age (e.g. 20)</label>
                </div>
                <div className="input-field col s4">
                    <select style={{border: "1px solid rgb(0, 0, 0)"}} className="browser-default" required value={this.state.el} onChange={this.onemergencylevelChanged.bind(this)}>
                        <option value="" disabled>Select Emergency Level</option>
                        <option>Low</option>
                        <option>High</option>
                    </select>
                </div>
            </div>
            <div className="row">
                   <Select
                   styles={styles}
                   closeMenuOnSelect={false}
                   onSelect={this.onSelect} // Function will trigger on select event
    onRemove={this.onRemove}
    options={options} 
    displayValue="value" 
    placeholder="Please select the symptoms"
    maxMenuHeight={100} 
    isMulti
    />
        <br></br>
        <br></br>
        <br></br>
        <br></br>
        <br></br>
        <div className="row">
          <div className="input-field col s12">
          <button className="btn waves-effect waves-light light-blue darken-3" type="submit" name="action">Submit
                        <i className="material-icons right">send</i>
         </button>
          </div>
        </div>
            </div>       
        </form>

    </div>
      )
}
}

}

