import React, { Component } from 'react';
import './login.css';
import { FaUserAlt, FaKey } from 'react-icons/fa';
import swal from 'sweetalert';
import { Form, Button } from 'react-bootstrap';
import AuthService from './AuthService/AuthService'
import datalist from 'react-datalist';

class login extends Component {

  constructor(props) {
    super(props)
    this.state = {
      login: true,
      signup: false,
      userName: '',
      password: '',
      phone: '',
      email: '',
      LcNo: '',
      Location: '',
      name: '',
      data: ['Mira Bhayander', 'Delhi', 'Banglore', 'Jodpur', 'Aurangabad', 'Pune', 'Nagpur', 'Vasai-Virar', 'Navghar', 'Nasik', 'Gujrat', 'Panjab', 'Chennai'],
      address: '',
      UserType: 'Distributer',
      formErrors: { email: '', password: '', phone: '', first: '', user: '' },
      emailValid: false,
      passwordValid: false,
      phoneValid: false,
      firstValid: false,
      formValid1: false,
      formValid2: false,
      userValid: false,
      checkforusername: ''

    }
    this.Auth = new AuthService();

  }


  validateField(fieldName, value) {

    let fieldValidationErrors = this.state.formErrors;
    let emailValid = this.state.emailValid;
    let passwordValid = this.state.passwordValid;
    let phoneValid = this.state.phoneValid;
    let firstValid = this.state.firstValid;
    let userValid = this.state.userValid;
    switch (fieldName) {
      case 'email':
        emailValid = value.match(/^([\w.%+-]+)@([\w-]+\.)+([\w]{2,})$/i);
        fieldValidationErrors.email = emailValid ? '' : 'Email is invalid';
        break;
      case 'password':
        passwordValid = value.length >= 6;
        fieldValidationErrors.password = passwordValid ? '' : 'Password is too short';
        break;
      case 'phone':
        phoneValid = value.match(/^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$/)
        fieldValidationErrors.phone = phoneValid ? '' : 'Phone No. is invalid';
        break;
      case 'name':
        firstValid = value.length > 3
        fieldValidationErrors.first = firstValid ? '' : 'First name is too small';
        break;
      case 'userName':
        userValid = value.length > 4
        fieldValidationErrors.user = userValid ? '' : 'Username is too small';
        break;
      default:
        break;
    }
    this.setState({
      formErrors: fieldValidationErrors,
      emailValid: emailValid,
      phoneValid: phoneValid,
      firstValid: firstValid,
      passwordValid: passwordValid,
      userValid: userValid
    }, this.validateForm);
  }

  validateForm() {
    // console.log(this.state)
    this.setState({
      formValid1: this.state.firstValid && this.state.emailValid && this.state.phoneValid && this.state.userValid && this.state.passwordValid,
    });
  }


  handleFormSubmit1 = (e) => {
    // console.log(this.state)
    e.preventDefault();
    // console.log(this.state.LcNo);
    this.Auth.fetch('http://localhost:5000/api/signup', {
      method: 'POST', body: JSON.stringify({

        "email": this.state.email,
        "password": this.state.password,
        "userName": this.state.userName,
        "name": this.state.name,
        "LcNo": this.state.LcNo,
        'phone': this.state.phone,
        "address": this.state.address,
        "location": this.state.Location,
        "userType": this.state.UserType

      })
    }).then(res => {
      // console.log("signup", res)
      this.props.history.replace('/')
    })
      .catch(err => {
        // console.log('signup', err)
      })
  }


  handleFormSubmit = (e) => {
    // e.preventDefault();

    // this.Auth.login(this.state.username, this.state.password)
    e.preventDefault();
    // console.log(this.state)
    this.Auth.login(this.state.userName, this.state.password)
      .then(res => {
        if (this.state.userName === 'admin')
          this.props.history.replace('/Admin');
        else
          this.props.history.replace('/');
      })
      .catch(err => {
        if (err == "TypeError: Cannot read property 'json' of undefined") {
          // console.log("I did it")
          swal({
            title: "Please Note",
            text: "Wrong Username or Password",
            icon: "warning",
            dangerMode: true,
          }).then(willbe => {
            window.location.reload();
          })
          // alert(err);
        }
        else if (err == "TypeError: Failed to fetch") {
          // console.log(err)
          // alert(err);
        }

        // console.log("This is err", err)

      })

  }


  handleChange = (e) => {
    let x = e.target.name
    let value = e.target.value
    this.setState(
      {
        [x]: e.target.value
      },
      () => { this.validateField(x, value) }
    )
  }


  handleUsernameChange = (e) => {
    let x = e.target.name
    let value = e.target.value
    this.setState(
      {
        [x]: e.target.value
      },
      () => { this.validateField(x, value) }
    )

    this.Auth.fetch('http://localhost:5000/api/checkforusername', {
      method: 'POST', body: JSON.stringify({

        "username": value,
      })
    }).then(res => {
      // console.log("signup", res)
      // console.log(res.length)
      if (res.length > 0) {
        this.setState({ checkforusername: 'Username already exist' })
      }
      else {
        this.setState({ checkforusername: '' })
      }
    })
      .catch(err => {
        // console.log('signup', err)
      })
  }

  handleThisChange = (e) => {
    this.setState(
      {
        UserType: e.target.value
      }
    )
  }


  componentWillMount() {
    if (this.Auth.loggedIn())
      this.props.history.replace('/');
  }


  loginstateHandler = () => {
    this.setState({ login: false });

    this.setState({ signup: true });
  }



  signupstateHandler = () => {

    this.setState({ login: true });

    this.setState({ signup: false });
  }



  render() {
    return (

      <div className="loginMainDiv">
        <div className="LFirst">
          <header className="toolbar">
            <nav className="nevigation_menu">
              <div className="Llogo_style">
                <p className="MYAPPNAME">Medicare</p>
              </div>
            </nav>
          </header>
        </div>
        {
          this.state.login === true ?
            <div className="LSecond">
              <div className="Logindiv">
                <div className="TopDesc">
                  <h3>Login</h3><hr />
                </div>
                <div className="Lformdiv">
                  <form>
                    <div>
                      <span style={{ float: 'left', marginRight: 250 }}>Username:</span>
                      <span style={{ 'color': 'red', float: 'left', fontSize: 16 }}></span>
                      <input type="text" name='userName' required onChange={this.handleChange} style={{ border: 'none', textIndent: 35 }} /><br /><br />
                      <p style={{ marginTop: -56, fontSize: 17, marginLeft: 10, opacity: 0.7, width: 20 }}><FaUserAlt /></p>
                    </div>
                    <div>
                      <span style={{ float: 'left', marginRight: 250 }}>Password:</span>
                      <span style={{ 'color': 'red', float: 'left', fontSize: 16 }}></span>
                      <input type="password" name='password' required onChange={this.handleChange} style={{ border: 'none', textIndent: 35 }} /><br /><br />
                      <p style={{ marginTop: -56, fontSize: 17, marginLeft: 10, opacity: 0.7, width: 20 }}><FaKey /></p>

                    </div>
                    <Button type="submit" variant="primary" className="formbut" onClick={this.handleFormSubmit}>Sign In</Button><br /><br />

                  </form>
                </div>
                <hr />
                <div className="Lredirectdiv">
                  <p>Not a member</p><p className="clickonme" onClick={this.loginstateHandler}>Sign Up</p>
                </div>
              </div>
            </div>
            : null

        }


        {
          this.state.signup === true ?
            <div className="LSecond">
              <div className="Logindiv">
                <div className="TopDesc">
                  <h3>Sign Up</h3><hr />
                </div>
                <div className="Lformdiv">
                  <form>
                    <div>
                      <span style={{ float: 'left', marginRight: 240 }}>Name:</span>
                      <span style={{ 'color': 'red', float: 'left', fontSize: 16 }}>{this.state.formErrors.first}</span>
                      <input type="text" name='name' required onChange={this.handleChange} style={{ border: 'none', textIndent: 8 }} /><br /><br />
                    </div>
                    <div>
                      <span style={{ float: 'left', marginRight: 200 }}>Username:</span>
                      <span style={{ 'color': 'red', float: 'left', fontSize: 16 }}>{this.state.formErrors.user}</span>
                      <span style={{ 'color': 'red', float: 'left', fontSize: 16 }}>{this.state.checkforusername}</span>
                      <input type="text" name='userName' required onChange={this.handleUsernameChange} style={{ border: 'none', textIndent: 8 }} /><br /><br />
                    </div>

                    <div>
                      <span style={{ float: 'left', marginRight: 245 }}>Email:</span>
                      <span style={{ 'color': 'red', float: 'left', fontSize: 16 }}>{this.state.formErrors.email}</span>
                      <input type="text" name='email' required onChange={this.handleChange} style={{ border: 'none', textIndent: 8 }} /><br /><br />
                    </div>

                    <div>
                      <span style={{ float: 'left' }}>MetaMask Address:</span>
                      <span style={{ 'color': 'red', float: 'left', fontSize: 16 }}></span>
                      <input type="text" name='address' required onChange={this.handleChange} style={{ border: 'none', textIndent: 8 }} /><br /><br />
                    </div>

                    <div>
                      <span style={{ float: 'left', marginRight: 230 }}>Phone:</span>
                      <span style={{ 'color': 'red', float: 'left', fontSize: 16 }}>{this.state.formErrors.phone}</span>
                      <input type="text" name='phone' required onChange={this.handleChange} style={{ border: 'none', textIndent: 8 }} /><br /><br />
                    </div>

                    <Form.Group controlId="exampleForm.ControlSelect1">
                      <span style={{ float: 'left', marginRight: 200, marginBottom: 16 }}>UserType:</span>
                      <Form.Control as="select" style={{ border: 'none', }} value={this.state.UserType} onChange={this.handleThisChange}>
                        <option>Manufacturer</option>
                        <option>Distributer</option>
                        <option>Retailer</option>
                      </Form.Control>
                    </Form.Group>


                    <div>
                      <span style={{ float: 'left' }}>Lisence No.:</span>
                      <span style={{ 'color': 'red', float: 'left', fontSize: 16 }}></span>
                      <input type="text" name='LcNo' required onChange={this.handleChange} style={{ border: 'none', textIndent: 8 }} /><br /><br />
                    </div>


                    <div>
                      <span style={{ float: 'left' }}>Location:</span>
                      <span style={{ 'color': 'red', float: 'left', fontSize: 16 }}></span>
                      <input type="text" name='Location' list="data" required onChange={this.handleChange} style={{ border: 'none', textIndent: 8 }} /><br /><br />

                      <datalist id="data" >
                        {this.state.data.map(k =>
                          <option key={k} value={k} />
                        )}
                      </datalist>
                    </div>


                    <div>
                      <span style={{ float: 'left', marginRight: 200 }}>Password:</span>
                      <span style={{ 'color': 'red', float: 'left', fontSize: 16 }}>{this.state.formErrors.password}</span>
                      <input type="password" name='password' required onChange={this.handleChange} style={{ border: 'none', textIndent: 8 }} /><br /><br />

                    </div>
                    <Button type="submit" variant="primary" className="formbut" disabled={!this.state.formValid1} onClick={this.handleFormSubmit1}>Sign Up</Button><br /><br />

                  </form>
                </div>

                <hr />
                <div className="Lredirectdiv">
                  <p>Already a member</p><p className="clickonme" onClick={this.signupstateHandler}>Sign In</p>
                </div>
              </div>
            </div> : null}

      </div>


    );
  }
}

export default login