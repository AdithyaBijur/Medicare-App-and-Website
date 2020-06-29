import React, { Component } from 'react';
import './Admin_Home.css';

import { FiLogOut } from 'react-icons/fi';
import { FaRegUser, FaIndustry, FaServicestack } from 'react-icons/fa';

import { MdStore } from 'react-icons/md';
import { Nav, Navbar, Card, Container, Col, Row, Button } from 'react-bootstrap';
import AuthService from '../AuthService/AuthService.js';
import withAuth from '../withAuth'
import supplychain from '../supplychain';
import web3 from '../web3';
import swal from 'sweetalert';
const img = require('../assets/loader.gif');


class Admin_Home extends Component {


    componentWillMount() {
        this.getUsers()
        this.getDisplayUsers()
    }

    getDisplayUsers = () => {

        // console.log("results");
        this.Auth.fetch('http://localhost:5000/api/displayallusers', {

            method: 'POST', body: JSON.stringify({

            })
        }).then(res => {
            this.setState({ displayuserlist: res })
            // console.log(this.state)
        })
            .catch(err => {
                // console.log(err)
            })


    }


    getUsers = () => {

        this.Auth.fetch('http://localhost:5000/api/getalluser', {

            method: 'POST', body: JSON.stringify({

            })
        }).then(res => {
            this.setState({ userList: res })
            if (res.length > 0) {
                this.setState({
                    showInput: true
                })
            }
            else {
                this.setState({
                    showInput: false
                })
            }
            this.setState({ userListP: res })
            // console.log(this.state)
        })
            .catch(err => {
                // console.log(err)
            })


    }

    constructor(props) {
        super(props)
        this.Auth = new AuthService()
        this.state = {
            Name: '',
            userList: [],
            userListP: [],
            results: [],
            displayuserlist: [],
            myMed: false,
            myUser: true,
            loading: false,
            displayUser: false,
            manudis: false,
            distdis: false,
            retadis: false,
            showInput: false
        }
    }

    logout = () => {
        this.Auth.logout()
        this.setState()
    }


    myUserHandler = () => {
        this.setState({ myUser: true });

        this.setState({ myMed: false });

        this.setState({ displayUser: false });
    }


    myMedHandler = () => {
        this.setState({ myMed: true });

        this.setState({ myUser: false });

        this.setState({ displayUser: false });

    }

    displayUserHandler = () => {
        this.setState({ displayUser: true });

        this.setState({ myUser: false });

        this.setState({ myMed: false });
    }


    manuDisplay = () => {
        // console.log("You Clicked manufacturer");
        this.setState({ manudis: true });

        this.setState({ distdis: false });

        this.setState({ retadis: false });
    }

    distDisplay = () => {
        // console.log("You Clicked distributer");
        this.setState({ manudis: false });

        this.setState({ distdis: true });

        this.setState({ retadis: false });
    }

    retaDisplay = () => {

        // console.log("You Clicked retailer");
        this.setState({ manudis: false });

        this.setState({ distdis: false });

        this.setState({ retadis: true });
    }


    acceptHandler = (id, userName, typeofuser, address) => {
        // console.log("accept")

        swal({
            title: "Please Note",
            text: "Please accept the transaction in metamask and reject if any error",
            icon: "success",
            dangerMode: true,
        }).then(willde => {

            this.setState({ loading: true })
            const a = web3.eth.getAccounts().then(r => {

                // console.log(this.state.typeofuser)
                const am = supplychain.methods.setuser(typeofuser, address, userName).send({
                    from: r[0]
                }).then(re => {

                    this.Auth.fetch('http://localhost:5000/api/accept', {
                        method: 'POST', body: JSON.stringify({
                            Id: id
                            //send id and remove from notifs
                        })
                    }).then(res => {
                        this.setState({ loading: false })
                        this.getUsers()

                        // console.log(this.state)
                    })
                        .catch(err => {
                            //  console.log(err)
                        })

                }).catch(err => {
                    // console.log(err);
                    this.setState({ loading: false })
                })

            })
                .catch(err => {
                    // console.log(err)
                })

        })


    }

    declineHandler = (id) => {


        this.Auth.fetch('http://localhost:5000/api/reject', {
            method: 'POST', body: JSON.stringify({
                Id: id
                //send id and remove from notifs
            })
        }).then(res => {
            this.setState({})
            this.getUsers()
            this.getDisplayUsers()
            // console.log(this.state)
        })
            .catch(err => {
                // console.log(err)
            })

    }

    handleChange = (e) => {
        let x = e.target.name
        this.setState(
            {
                [x]: e.target.value
            }
        )
        if (e.target.value == '') {
            // console.log("INSIDE")
            this.getUsers()
        }
    }



    render() {



        if (this.state.loading === true) {
            return (<div className="Loader"><img src={img} className="Image" /></div>)
        }
        else {
            let disp = (
                <div className="NURD">
                    <h3 className="NUR">No new user request</h3>

                </div>
            );

            let dispmed = (
                <div className="NURD">
                    <h3 className="NUR">No Expired Medicines</h3>

                </div>
            );

            // let dispI = (<div>
            //     <input type="text" name='Name' className="searchinput" placeholder="Enter Username" onChange={this.handleChange} style={{ textIndent: 12 }} /><br /><br />
            // </div>)

            let dispI = '';
            let dispmedI = '';
            let manuc = 0;
            let distc = 0;
            let retac = 0;

            let dispmanuuser = '';
            let dispdistuser = '';
            let dispretauser = '';


            if (this.state.showInput) {
                dispI = (
                    <div>
                        <input type="text" name='Name' className="searchinput" placeholder="Enter Name" onChange={this.handleChange} style={{ textIndent: 12 }} /><br /><br />
                    </div>
                )
            }


            if (this.state.myUser) {
                // console.log(this.state.myUser)



                this.state.userList = this.state.userList.filter((send) => {
                    return send.name.indexOf(this.state.Name) !== -1;
                });

                // dispI = (
                //     <div>
                //         <input type="text" name='Name' className="searchinput" placeholder="Enter Name" onChange={this.handleChange} style={{ textIndent: 12 }} /><br /><br />
                //     </div>
                // )


                if (this.state.userList.length) {

                    console.log(this.state.userList)
                    disp = this.state.userList.map(r => {
                        // console.log(r)

                        return (
                            <Col sm={4}><Card style={{ marginBottom: 50 }} border="secondary" className="DisCard">
                                <Card.Body>

                                    <Card.Title>{r.name}</Card.Title>
                                    <Card.Text>

                                        <p className="CardTitle">Address :</p> <p className="CardContent">{r.address}</p>
                                        <p className="CardTitle">Username :</p> <p className="CardContent">{r.userName}</p>
                                        <p className="CardTitle">Account Type :</p> <p className="CardContent">{r.typeofuser}</p>
                                    </Card.Text>
                                </Card.Body>
                                <Card.Footer>
                                    <div >
                                        <Button variant="outline-success" className="abut" onClick={() => this.acceptHandler(r._id, r.userName, r.typeofuser, r.address)}>Accept</Button>
                                        <Button variant="outline-danger" className="rejectBut abut" onClick={() => this.declineHandler(r._id)}>Decline</Button>
                                    </div>
                                </Card.Footer>
                            </Card></Col>
                        )
                    })
                }

            }


            if (this.state.displayuserlist.length) {

                // console.log("this is all users", this.state.displayuserlist)

                dispmanuuser = this.state.displayuserlist.map(r => {
                    if (r.typeofuser == "Manufacturer") {
                        manuc = manuc + 1;
                        return (<Col sm={4}><Card style={{ marginBottom: 50 }} border="secondary" className="DisCard">
                            <Card.Body>

                                <Card.Title>{r.name}</Card.Title>
                                <Card.Text>

                                    <p className="CardTitle">Address : </p>  <p className="CardContent">{r.address}</p>
                                    <p className="CardTitle">Username : </p><p className="CardContent">{r.userName}</p>
                                    <p className="CardTitle"> Account Type :</p>  <p className="CardContent">{r.typeofuser}</p>
                                    <p className="CardTitle"> Phone :</p>  <p className="CardContent">{r.phone}</p>

                                </Card.Text>
                            </Card.Body>
                            {/* <Card.Footer>

                            </Card.Footer> */}
                        </Card></Col>
                        )
                    }
                })



                dispdistuser = this.state.displayuserlist.map(r => {
                    if (r.typeofuser == "Distributer") {
                        distc = distc + 1;
                        return (<Col sm={4}><Card style={{ marginBottom: 50 }} border="secondary" className="DisCard">
                            <Card.Body>

                                <Card.Title>{r.name}</Card.Title>
                                <Card.Text>

                                    <p className="CardTitle">Address : </p>  <p className="CardContent">{r.address}</p>
                                    <p className="CardTitle">Username : </p><p className="CardContent">{r.userName}</p>
                                    <p className="CardTitle"> Account Type :</p>  <p className="CardContent">{r.typeofuser}</p>
                                    <p className="CardTitle"> Phone :</p>  <p className="CardContent">{r.phone}</p>

                                </Card.Text>
                            </Card.Body>
                            {/* <Card.Footer>

                            </Card.Footer> */}
                        </Card></Col>
                        )
                    }
                })




                dispretauser = this.state.displayuserlist.map(r => {
                    if (r.typeofuser == "Retailer") {
                        retac = retac + 1;
                        return (<Col sm={4}><Card style={{ marginBottom: 50 }} border="secondary" className="DisCard">
                            <Card.Body>

                                <Card.Title>{r.name}</Card.Title>
                                <Card.Text>

                                    <p className="CardTitle">Address : </p>  <p className="CardContent">{r.address}</p>
                                    <p className="CardTitle">Username : </p><p className="CardContent">{r.userName}</p>
                                    <p className="CardTitle"> Account Type :</p>  <p className="CardContent">{r.typeofuser}</p>
                                    <p className="CardTitle"> Phone :</p>  <p className="CardContent">{r.phone}</p>

                                </Card.Text>
                            </Card.Body>
                            {/* <Card.Footer>

                            </Card.Footer> */}
                        </Card></Col>
                        )
                    }
                })



            }

            return (

                <div className="maindiv">
                    <Navbar collapseOnSelect expand="lg" bg="dark" variant="dark">
                        <Navbar.Brand href="">Medicare</Navbar.Brand>
                        <Navbar.Toggle aria-controls="responsive-navbar-nav" />
                        <Navbar.Collapse id="responsive-navbar-nav">
                            <Nav className="mr-auto">

                            </Nav>
                            <Nav>
                                <Nav.Link eventKey={1} href="" onClick={this.myUserHandler}>
                                    Home
                                 </Nav.Link>
                                {/* <Nav.Link eventKey={2} href="" onClick={this.myMedHandler}>
                                    Expired Med
                                 </Nav.Link> */}
                                <Nav.Link eventKey={4} href="" onClick={this.displayUserHandler}>
                                    Users
                                 </Nav.Link>
                                <Nav.Link eventKey={3} href="/" style={{ 'color': 'white', fontWeight: 550 }} onClick={this.logout}>LogOut <FiLogOut style={{ fontSize: 20, marginBottom: 3 }} /></Nav.Link>
                            </Nav>
                        </Navbar.Collapse>
                    </Navbar>


                    {
                        this.state.myUser === true ?
                            <Container style={{ marginTop: 50 }}>
                                <Row>
                                    <Col sm>
                                        {/* <input type="text" name='Name' className="searchinput" placeholder="Enter Username" onChange={this.handleChange} style={{  textIndent: 12}}/><br /><br /> */}
                                        {dispI}
                                    </Col>
                                    <Col sm>

                                    </Col>
                                </Row>

                                <br />
                                <br />

                                <Row>

                                    {disp}

                                </Row>

                            </Container>
                            : null

                    }

                    {
                        this.state.myMed === true ?
                            <Container style={{ marginTop: 50 }}>
                                <Row>
                                    <Col sm>
                                        <input type="text" name='Name' className="searchinput" placeholder="Enter Medicine by id" onChange={this.handleChange} style={{ textIndent: 12 }} /><br /><br />
                                    </Col>
                                    <Col sm>

                                    </Col>
                                </Row>

                                <br />
                                <br />

                                <Row>

                                    {dispmed}

                                </Row>

                            </Container>
                            : null
                    }



                    {
                        this.state.displayUser === true ?
                            <Container style={{ marginTop: 50 }}>
                                <Row>
                                    <Col sm>

                                    </Col>
                                    <Col sm>
                                        <Card className="text-center" style={{ border: '1px solid ', height: '82%' }}>
                                            <Card.Body >
                                                <Card.Title><FaRegUser style={{ float: 'left', fontSize: 30, marginTop: -5 }} />Total Users: {this.state.displayuserlist.length}   </Card.Title>
                                            </Card.Body>
                                        </Card>
                                    </Col>
                                    <Col sm>

                                    </Col>
                                </Row>

                                <br />
                                <br />

                                <Row>
                                    <Col sm>
                                        <div className="disbox" onClick={this.manuDisplay}>
                                            <div className="dbfd">
                                                <FaIndustry className="dbfdlogo" />
                                                <p>Manufacturer</p>



                                            </div>
                                            <div className="dbsd">
                                                <h4>{manuc}</h4>
                                            </div>
                                        </div>
                                    </Col>

                                    <Col sm>
                                        <div className="disbox" onClick={this.distDisplay}>
                                            <div className="dbfd">
                                                <FaServicestack className="dbfdlogo" />
                                                <p>Distributers</p>



                                            </div>
                                            <div className="dbsd">
                                                <h4>{distc}</h4>
                                            </div>
                                        </div>

                                    </Col>

                                    <Col sm>
                                        <div className="disbox" onClick={this.retaDisplay}>
                                            <div className="dbfd">
                                                <MdStore className="dbfdlogo" />
                                                <p>Retailers</p>



                                            </div>
                                            <div className="dbsd">
                                                <h4>{retac}</h4>
                                            </div>
                                        </div>

                                    </Col>
                                </Row>

                                <br />
                                <br />


                                {
                                    this.state.manudis === true ?
                                        <Row>
                                            {dispmanuuser}
                                        </Row>
                                        : null
                                }

                                {
                                    this.state.distdis === true ?
                                        <Row>
                                            {dispdistuser}
                                        </Row>
                                        : null
                                }

                                {
                                    this.state.retadis === true ?
                                        <Row>

                                            {dispretauser}
                                        </Row>
                                        : null
                                }




                            </Container>

                            : null

                    }


                </div>

            );
        }


    }
}

export default withAuth(Admin_Home)