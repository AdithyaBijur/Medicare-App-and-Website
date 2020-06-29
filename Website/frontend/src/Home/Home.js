import React, { Component } from 'react';
import './Home.css';
import { FiLogOut } from 'react-icons/fi';
import { GoSearch } from 'react-icons/go';
import { Nav, Navbar, Card, Container, Col, Row, Button } from 'react-bootstrap';
import AuthService from '../AuthService/AuthService.js';
import withAuth from '../withAuth'
import supplychain from '../supplychain';
import web3 from '../web3';
import swal from 'sweetalert';
const img = require('../assets/loader.gif');

class Home extends Component {

    componentWillMount() {
        this.updateLoginAccountStatus()

        this.getTrans()
        this.getNotifs()
        this.getMaxId()
        this.Auth.fetch('http://localhost:5000/api/getuser', {
            method: 'POST', body: JSON.stringify({

            })
        }).then(res => {
            // console.log("this is accepted or not", res.accepted)
            this.setState({ typeofuser: res.typeofuser, userName: res.userName, addrs: res.address, accepted: res.accepted, accountName: res.name })
            web3.eth.getAccounts((err, accounts) => {
                // console.log(err, accounts)
                if (err) {
                    // console.log('An error occurred ' + err);
                } else if (accounts[0] != res.address) {
                    // alert( 'Please login into MetaMask with your registered account..!');
                    swal({
                        title: "Please Note",
                        text: "Please login into MetaMask with your registered account..!",
                        icon: "warning",
                        dangerMode: true,
                    }).then(willD => {
                        this.logout()
                        window.location.reload();
                    })

                }
            });
        })
            .catch(err => {
                // console.log('view own Question error', err)
            })

    }
    updateLoginAccountStatus = () => {

        web3.eth.getAccounts((err, accounts) => {
            // console.log(err, accounts)
            if (err) {
                // console.log('An error occurred ' + err);
            } else if (accounts.length == 0) {
                // alert( 'Please login to MetaMask..!');

                swal({
                    title: "Please Note",
                    text: "Please login to MetaMask..!",
                    icon: "warning",
                    dangerMode: true,
                }).then(a => {
                    this.logout()
                    window.location.reload();

                })

            }
        });

        this.Auth.fetch('http://localhost:5000/api/getuser', {
            method: 'POST', body: JSON.stringify({

            })
        }).then(res => {
            if (res.accepted === false) {
                swal({
                    title: "Please Note",
                    text: "Admin Not Approve you yet Please Wait",
                    icon: "warning",
                    dangerMode: true,
                }).then(a => {
                    this.logout()
                    window.location.reload();

                })
            }
        });
    }

    getTrans = () => {
        const a = web3.eth.getAccounts().then(r => {
            // console.log(r[0] + " This is current account address");
            // console.log(this.state.Name)
            this.Auth.fetch('http://localhost:5000/api/gettrans', {

                method: 'POST', body: JSON.stringify({
                    acc: r[0],
                    user: this.state.Name,
                    userName: this.state.userName
                })
            }).then(res => {
                this.setState({ results: res })
                // console.log(this.state)
                // console.log("This is Transaction ", this.state.results)
            })
                .catch(err => {
                    // console.log(err)
                })
        }).catch(err => {
            //  console.log(err)
        })
    };

    getNotifs = () => {
        const a = web3.eth.getAccounts().then(r => {
            // console.log(r[0]);
            this.Auth.fetch('http://localhost:5000/api/getnotifs', {
                method: 'POST', body: JSON.stringify({
                    acc: r[0],
                    userName: this.state.userName
                })
            }).then(res => {
                this.setState({ notif: res })
                // console.log(this.state)
            })
                .catch(err => {
                    // console.log(err)
                })
        }).catch(err => {
            // console.log(err) 
        })
    }

    getMaxId = () => {
        this.Auth.fetch('http://localhost:5000/api/givemaxeid', {
            method: 'POST', body: JSON.stringify({

            })
        }).then(res => {
            let a = Math.max(...res)
            if (a == "-Infinity") {
                this.setState({ maxeid: 100 })
            }
            else {
                this.setState({ maxeid: a + 1 })
            }
            // console.log("HHHHHHHHHHHHHHHHHHHHHH", this.state)
        })
            .catch(err => {
                // console.log(err)
            })

    }



    addmed = () => {


        this.mytryHandler()
        // alert("Please accept the transaction in metamask and reject if any error")
        swal({
            title: "Please Note",
            text: "Please accept the transaction in metamask and reject if any error",
            icon: "success",
            dangerMode: true,
        }).then(willDelete => {
            this.setState({ loading: true })
            const a = web3.eth.getAccounts().then(r => {
                // console.log(r[0]);
                // console.log(this.state.typeofuser)
                if (this.state.typeofuser == "Manufacturer") {
                    var date = new Date();
                    // console.log(Number(this.state.expire))
                    date.setDate(date.getDate() + Number(this.state.expire));
                    // console.log(date);
                    var dst = date.toString();
                    const am = supplychain.methods.setmed(this.state.medname, this.state.maxeid, this.state.eid, this.state.to, this.state.expire, dst).send({
                        from: r[0]
                    }).then(re => {
                        const allLines = this.fillRange(this.state.maxeid, this.state.eid);

                        // console.log(re.transactionHash)
                        this.Auth.fetch('http://localhost:5000/api/addmed', {
                            method: 'POST', body: JSON.stringify({
                                tid: re.transactionHash,
                                name: this.state.medname,
                                Mname: this.state.userName,
                                sid: this.state.maxeid,
                                eid: this.state.eid,
                                medlist: allLines,
                                to: this.state.to,
                                toname: this.state.toname,
                                acc: r[0],
                                exp: date
                            })
                        }).then(res => {
                            // console.log(res)
                            this.setState({ results: res, loading: false })
                            // console.log(this.state)
                            window.location.reload();

                        })
                            .catch(err => {
                                // console.log(err)
                            })

                    }).catch(err => {
                        // console.log(err)
                        this.setState({ loading: false })
                    })


                    // I'm deliberately missing gas option here
                    // const data = await contract.methods.myMethod().send({ from: account, gasPrice });



                }
                if (this.state.typeofuser == "Distributer") {
                    let id = this.state.id
                    // console.log(id)
                    const am = supplychain.methods.setdistdetails(this.state.to, this.state.sid, this.state.eid).send({
                        from: r[0]
                    }).then(re => {
                        // console.log("this is very good", re)
                        // console.log(re.transactionHash)
                        this.Auth.fetch('http://localhost:5000/api/setdist', {
                            method: 'POST', body: JSON.stringify({
                                tid: re.transactionHash,
                                medname: this.state.passmedname,
                                sid: this.state.sid,
                                eid: this.state.eid,
                                to: this.state.to,
                                toname: this.state.toname,
                                acc: r[0]

                            })
                        }).then(res => {
                            this.setState({ results: res, loading: false })
                            // console.log(this.state)
                            this.Auth.fetch('http://localhost:5000/api/updatenot', {
                                method: 'POST', body: JSON.stringify({
                                    Id: id,
                                    med: this.state.eid - this.state.sid + 1
                                    //send id and remove from notifs
                                })
                            }).then(res => {
                                this.setState({ results: res, id: '' })
                                // console.log(this.state)
                                window.location.reload();
                            })
                                .catch(err => {
                                    // console.log(err)
                                })

                        })
                            .catch(err => {
                                // console.log(err)
                            })

                    }).catch(err => {
                        // console.log(err)
                        this.setState({ loading: false })
                    })



                }
                if (this.state.typeofuser == "Retailer") {
                    let id = this.state.id
                    const am = supplychain.methods.sell(this.state.sid).send({
                        from: r[0]
                    }).then(re => {
                        // console.log(re.transactionHash)
                        this.Auth.fetch('http://localhost:5000/api/sell', {
                            method: 'POST', body: JSON.stringify({
                                tid: re.transactionHash,
                                medname: this.state.passmedname,
                                sid: this.state.sid,

                                acc: r[0]

                            })
                        }).then(res => {
                            this.setState({ results: res, loading: false })
                            // console.log(this.state)
                            this.Auth.fetch('http://localhost:5000/api/updatenot', {
                                method: 'POST', body: JSON.stringify({
                                    Id: id,
                                    med: 1
                                    //send id and remove from notifs
                                })
                            }).then(res => {
                                this.setState({ results: res, id: '' })
                                // console.log(this.state)
                                window.location.reload();
                            })
                                .catch(err => {
                                    // console.log(err)
                                })

                        })
                            .catch(err => {
                                // console.log(err)
                            })

                    }).catch(err => {
                        // console.log(err)
                        this.setState({ loading: false })
                    })



                }
            }).catch(err => {
                // console.log(err)
                this.setState({ loading: false })
            })
            this.setState()
        })

    }

    constructor(props) {
        super(props)
        this.Auth = new AuthService()
        this.state = {
            mytry: true,
            id: '',
            loading: false,
            addmedi: false,
            userName: '',
            notifi: false,
            showForward: false,
            typeofuser: '',
            Name: '',
            results: [],
            notif: [],
            medname: '',
            manuname: '',
            sid: '',
            eid: '',
            to: '',
            toname: '',
            medlist: [],
            color: ['rgba(252, 222, 251,0.1)'],
            accountName: '',
            showeid: '',
            maxeid: '',
            passmedname: ''

        }
    }
    fillRange = (start, end) => {
        var a = new Array(end - start + 1);
        var i = 0;
        for (i = 0; i <= (end - start); i++)
            a[i] = Number(start) + i;

        return a
    };

    handleChange = (e) => {
        let x = e.target.name
        this.setState(
            {
                [x]: e.target.value
            }
        )
        this.getTrans()
    }


    mytryHandler = () => {
        this.getTrans()

        this.setState({ mytry: true });

        this.setState({ addmedi: false });

        this.setState({ notifi: false });
    }



    adddmediHandler = () => {
        this.setState({ mytry: false });

        this.setState({ addmedi: true });

        this.setState({ notifi: false });
    }



    notifiHandler = () => {
        this.setState({ mytry: false });

        this.setState({ addmedi: false });

        this.setState({ notifi: true });
    }


    acceptHandler = (sid, eid, from, id) => {

        // alert("Please accept the transaction in metamask and reject if any error")
        swal({
            title: "Please Note",
            text: "Please accept the transaction in metamask and reject if any error",
            icon: "success",
            dangerMode: true,
        }).then(willDe => {
            this.setState({ loading: true })
            const a = web3.eth.getAccounts().then(r => {
                // console.log(from)
                if (this.state.typeofuser == "Distributer") {
                    const am = supplychain.methods.acceptdist(sid, eid, from).send({
                        from: r[0]
                    }).then(re => {
                        this.setState({ showForward: true, loading: false });
                        this.Auth.fetch('http://localhost:5000/api/acceptmeds', {
                            method: 'POST', body: JSON.stringify({

                                //send id
                                Id: id


                            })
                        }).then(res => {
                            this.getNotifs()
                            this.setState({ results: res })
                            // console.log(this.state)
                        })
                            .catch(err => {
                                // console.log(err)
                            })
                    }).catch(err => {
                        // console.log(err)
                        this.setState({ loading: false })
                    })



                }
                if (this.state.typeofuser == "Retailer") {
                    const am = supplychain.methods.setretaildetails(sid, eid, from).send({
                        from: r[0]
                    }).then(re => {
                        this.setState({ showForward: true, loading: false });
                        this.Auth.fetch('http://localhost:5000/api/acceptmeds', {
                            method: 'POST', body: JSON.stringify({

                                //send id
                                Id: id


                            })
                        }).then(res => {
                            this.getNotifs()
                            this.setState({ results: res })
                            // console.log(this.state)
                        })
                            .catch(err => {
                                // console.log(err)
                            })
                    }).catch(err => {
                        // console.log(err)
                        this.setState({ loading: false })
                    })



                }

            }).catch(err => {
                // console.log(err)
            })
        })


    }


    receiveHandler = (sid, eid, from, id) => {
        const allLine = this.fillRange(sid, eid);
        swal({
            title: "Please Note",
            text: "Please accept the transaction in metamask and reject if any error",
            icon: "success",
            dangerMode: true,
        }).then(willDe => {
            this.setState({ loading: true })
            const a = web3.eth.getAccounts().then(r => {
                // console.log(from)
                if (this.state.typeofuser == "Distributer") {
                    const am = supplychain.methods.rdist(sid, eid, from).send({
                        from: r[0]
                    }).then(re => {

                        this.Auth.fetch('http://localhost:5000/api/acceptmeds', {
                            method: 'POST', body: JSON.stringify({

                                //send id
                                Id: id


                            })
                        }).then(res => {
                            this.getNotifs()
                            this.setState({ results: res, loading: false })
                            // console.log(this.state)
                        })
                            .catch(err => {
                                // console.log(err)
                            })
                    }).catch(err => {
                        // console.log(err)
                        this.setState({ loading: false })
                    })


                }
                else if (this.state.typeofuser == "Manufacturer") {
                    const am = supplychain.methods.rman(sid, eid, from).send({
                        from: r[0]
                    }).then(re => {

                        this.Auth.fetch('http://localhost:5000/api/acceptmeds', {
                            method: 'POST', body: JSON.stringify({

                                //send id
                                Id: id


                            })
                        }).then(res => {
                            this.getNotifs()
                            this.setState({ results: res, loading: false })
                            // console.log(this.state)
                        })
                            .catch(err => {
                                // console.log(err)
                            })
                    }).catch(err => {
                        // console.log(err)
                        this.setState({ loading: false })
                    })


                }


            }).catch(err => {
                // console.log(err)
            })
        }).catch(err => {
            // console.log(err) 
        })

    }


    declineHandler = (sid, eid, from, id, medname) => {
        const allLine = this.fillRange(sid, eid);
        console.log("this is med name", medname)
        swal({
            title: "Please Note",
            text: "Please accept the transaction in metamask and reject if any error",
            icon: "success",
            dangerMode: true,
        }).then(willde => {
            this.setState({ loading: true })
            const a = web3.eth.getAccounts().then(r => {
                // console.log(from)

                const am = supplychain.methods.decline(sid, eid, from).send({
                    from: r[0]
                }).then(re => {
                    this.setState({ showForward: true });
                    this.Auth.fetch('http://localhost:5000/api/rejectmeds', {
                        method: 'POST', body: JSON.stringify({

                            //send id
                            Id: id,
                            sid: sid,
                            eid: eid,
                            medlist: allLine,
                            medname: medname,
                            tid: re.transactionHash,


                        })
                    }).then(res => {
                        this.getNotifs()
                        this.setState({ results: res, loading: false })
                        this.setState({})
                        // console.log(this.state)
                    })
                        .catch(err => {
                            // console.log(err)
                        })
                }).catch(err => {
                    // console.log(err)
                    this.setState({ loading: false })
                })


            }).catch(err => {
                // console.log(err)
            })
        })
        // alert("Please accept the transaction in metamask and reject if any error")

    }

    forwardHandler = (id, medlist, sid, passmedname) => {
        this.setState({ id: id, sid: sid })
        let a = medlist.length;
        var b = "Max " + medlist[a - 1];
        this.setState({ showeid: b })
        // console.log(medlist)
        this.setState({ medlist: medlist })

        this.setState({ addmedi: true });


        this.setState({ notifi: false, passmedname: passmedname });

    }

    backTrackHandler = (id, sid, eid, from, medlist, medname) => {
        const allLine = this.fillRange(sid, eid);
        swal({
            title: "Please Note",
            text: "Please accept the transaction in metamask and reject if any error",
            icon: "success",
            dangerMode: true,
        }).then(willDe => {
            this.setState({ loading: true })
            const a = web3.eth.getAccounts().then(r => {
                // console.log(from)
                if (this.state.typeofuser == "Distributer") {
                    const am = supplychain.methods.backtrack(sid, eid).send({
                        from: r[0]
                    }).then(re => {

                        this.Auth.fetch('http://localhost:5000/api/backtrack', {
                            method: 'POST', body: JSON.stringify({

                                //send id
                                //send id
                                Id: id,
                                sid: sid,
                                eid: eid,
                                medlist: allLine,
                                medname: medname,
                                tid: re.transactionHash,


                            })
                        }).then(res => {
                            this.getNotifs()
                            this.setState({ results: res, loading: false })
                            // console.log(this.state)
                        })
                            .catch(err => {
                                // console.log(err)
                            })
                    }).catch(err => {
                        // console.log(err)
                        this.setState({ loading: false })
                    })


                }


            }).catch(err => {
                // console.log(err) 
            })
        }).catch(err => {
            // console.log(err) 
        })



    }



    logout = () => {
        this.Auth.logout()
        this.setState()
    }


    render() {
        if (this.state.loading === true) {
            return (<div className="Loader"><img className="Image" /></div>)
        }
        else {
            // this.getTrans()
            let disp = (
                <div className="NURD">
                    <h3 className="NUN">No Transaction Data</h3>
                </div>
            );
            let notif = ''
            let sb = (<div>
                <input type="text" name='Name' className="searchinput speclassi" placeholder="Enter Transaction Id" onChange={this.handleChange} style={{ float: 'left', textIndent: 8 }}></input><GoSearch style={{ float: 'left', marginTop: 10, marginLeft: -30, fontSize: 22, opacity: 0.8 }} /><br /><br />
            </div>)
            var colcou = -1;

            if (this.state.results.length > 0) {
                this.state.results = this.state.results.filter((send) => {
                    return send.transid.indexOf(this.state.Name) !== -1;
                });
            }


            if (this.state.results.length) {
                sb = (<div>
                    <input type="text" name='Name' className="searchinput speclassi" placeholder="Enter Transaction Id" onChange={this.handleChange} style={{ float: 'left', textIndent: 8 }}></input><GoSearch style={{ float: 'left', marginTop: 10, marginLeft: -30, fontSize: 22, opacity: 0.8 }} /><br /><br />
                </div>);
                disp = this.state.results.map(r => {

                    // console.log("This i want", r);
                    var res = r.dot.split("T");
                    var resdate = res[0];

                    let daychange = resdate.split('-');
                    let year = daychange[0];
                    let month = daychange[1];
                    let date = daychange[2];
                    // console.log(date);
                    var res1 = res[1].split(".")
                    var restime = res1[0];
                    // console.log(restime);
                    let hourminsec = restime.split(':')
                    let hour = parseInt(hourminsec[0])
                    let min = parseInt(hourminsec[1])
                    let sec = parseInt(hourminsec[2])
                    min = min + 30;
                    if (min > 60) {
                        min = min - 60;
                        hour = hour + 1;
                    }
                    hour = hour + 5;
                    if (hour > 24) {
                        if (date != 31) {
                            date = date + 1;
                        }
                        else {
                            date = 1;
                        }

                        hour = hour - 24;
                    }

                    daychange[0] = year.toString();
                    daychange[1] = month.toString();
                    daychange[2] = date.toString();
                    resdate = daychange.join('-');


                    hourminsec[0] = hour.toString();
                    hourminsec[1] = min.toString();
                    hourminsec[2] = sec.toString();
                    restime = hourminsec.join(':')
                    // console.log(restime);
                    if (colcou === 1) {
                        colcou = 0;
                    }
                    else {
                        colcou = colcou + 1;
                    }
                    if (r.Toname === undefined) {
                        r.Toname = "Customer"
                    }


                    return (<Col sm={4}>

                        <Card style={{ marginBottom: 50 }} border="secondary" className="detailbox">
                            <Card.Header style={{ fontWeight: 550 }}>{r.transid}</Card.Header>
                            <Card.Body style={{ backgroundColor: this.state.color[colcou] }}>
                                {/* <Card.Title>{r.transid}</Card.Title> */}
                                <Card.Text>
                                    {
                                        r.medname != undefined ?
                                            <div>
                                                <p className="CardTitle">Medicine Name : </p><p className="CardContent" style={{ color: 'blue', fontWeight: 500 }}>{r.medname}</p>
                                            </div> : <p></p>
                                    }
                                    <p className="CardTitle">From : </p><p className="CardContent">{r.name}</p>
                                    <p className="CardTitle">Address : </p><p className="CardContent">{r.from}</p>
                                    <p className="CardTitle">To : </p><p className="CardContent">{r.Toname}</p>
                                    {
                                        r.to !== undefined ?
                                            <div>
                                                <p className="CardTitle">Address : </p><p className="CardContent">{r.to}</p>
                                            </div> : null
                                    }
                                    <p className="CardTitle">Sid : </p><p className="CardContent"> {r.sid}</p>

                                    {
                                        r.eid !== undefined ?
                                            <div> <p className="CardTitle">Eid : </p><p className="CardContent">{r.eid}</p>
                                            </div> : null
                                    }
                                    <p className="CardTitle">Number Of Meds : </p><p className="CardContent">{r.meds}</p>
                                </Card.Text>
                            </Card.Body>
                            <Card.Footer>
                                <small className="text-muted "><p className="CardTitle">Trancastion date & time:</p><p className="CardContent">{resdate} {restime}</p></small>
                            </Card.Footer>
                        </Card>

                    </Col>
                    )
                })
            }
            notif = (
                <div className="NURD">
                    <h3 className="NUN" style={{ marginTop: 45 }}>No User Notifications</h3>

                </div>
            );
            var count = 0;
            var colco = -1;
            if (this.state.notif.length) {

                notif = this.state.notif.map(r => {
                    if (r.accepted == false) {
                        count = count + 1;
                    }
                    if (colco === 1) {
                        colco = 0;
                    }
                    else {
                        colco = colco + 1;
                    }

                    if (r.Toname == undefined) {
                        r.Toname = "Customer"
                    }


                    if (r.msg == undefined) {
                        // console.log("This is Proper medicine");
                        return (<Col sm={4}><Card style={{ marginBottom: 50 }} border="secondary" className="detailbox">
                            <Card.Header style={{ fontWeight: 550 }}>{r.transid}</Card.Header>
                            <Card.Body style={{ backgroundColor: this.state.color[colco] }}>
                                {/* <Card.Title>{r.transid}</Card.Title> */}
                                <Card.Text>
                                    {
                                        // console.log(r)
                                    }
                                    {
                                        r.medname != undefined ?
                                            <div>
                                                <p className="CardTitle">Medicine Name : </p><p className="CardContent" style={{ color: 'blue', fontWeight: 500 }}>{r.medname}</p>
                                            </div> : <p></p>
                                    }
                                    <p className="CardTitle">From : </p><p className="CardContent">{r.name}</p>
                                    <p className="CardTitle">Address : </p><p className="CardContent">{r.from}</p>
                                    <p className="CardTitle">To : </p><p className="CardContent">{r.Toname}</p>

                                    <p className="CardTitle">Address: </p><p className="CardContent">{r.to}</p>

                                    <p className="CardTitle">Sid : </p><p className="CardContent">{r.sid}</p>
                                    <p className="CardTitle">Eid : </p><p className="CardContent">{r.eid}</p>
                                    <p className="CardTitle">Number Of Meds : </p><p className="CardContent">{r.meds}</p>
                                </Card.Text>
                            </Card.Body>
                            <Card.Footer>
                                {
                                    r.accepted === false ?
                                        <div>
                                            <Button variant="outline-success" className="abut" onClick={() => this.acceptHandler(r.sid, r.eid, r.from, r._id)} value={r}>Accept</Button><Button variant="outline-danger" className="rejectBut abut" onClick={() => this.declineHandler(r.sid, r.eid, r.from, r._id, r.medname)} value={r}>Decline</Button>
                                        </div>
                                        : <Button variant="outline-primary" className="abut" onClick={() => { this.forwardHandler(r._id, r.medlist, r.sid, r.medname) }}>Forward</Button>
                                }
                            </Card.Footer>
                        </Card></Col>
                        )
                    }
                    else {
                        // console.log("Declined ", r.msg);
                        // console.log("Type of user active ", this.state.typeofuser)
                        let btou = '';
                        if (this.state.typeofuser !== "Manufacturer") {
                            btou = (<Button variant="outline-primary" className="abut" onClick={() => { this.backTrackHandler(r._id, r.sid, r.eid, r.from, r.medlist, r.medname) }}>BackTrack</Button>)
                        }
                        return (<Col sm={4}><Card style={{ marginBottom: 50 }} border="secondary" className="detailbox">
                            <Card.Header style={{ fontWeight: 550 }}>{r.transid}</Card.Header>
                            <Card.Body style={{ backgroundColor: this.state.color[colco] }}>
                                {/* <Card.Title>{r.transid}</Card.Title> */}
                                <Card.Text>
                                    {
                                        // console.log(r)
                                    }
                                    {
                                        r.medname != undefined ?
                                            <div>
                                                <p className="CardTitle">Medicine Name : </p><p className="CardContent" style={{ color: 'blue', fontWeight: 500 }}>{r.medname}</p>
                                            </div> : <p></p>
                                    }
                                    <p className="CardTitle">From : </p><p className="CardContent">{r.name}</p>
                                    <p className="CardTitle">Address : </p><p className="CardContent">{r.from}</p>
                                    <p className="CardTitle">To : </p><p className="CardContent">{r.Toname}</p>

                                    <p className="CardTitle">Address: </p><p className="CardContent">{r.to}</p>

                                    <p className="CardTitle">Sid : </p><p className="CardContent">{r.sid}</p>
                                    <p className="CardTitle">Eid : </p><p className="CardContent">{r.eid}</p>
                                    <p className="CardTitle">Number Of Meds : </p><p className="CardContent">{r.meds}</p>
                                </Card.Text>
                            </Card.Body>
                            <Card.Footer>
                                {
                                    r.accepted === false ?
                                        <div>
                                            <Button variant="outline-success" className="abut" onClick={() => this.receiveHandler(r.sid, r.eid, r.from, r._id)} value={r}>Receive</Button>
                                        </div>
                                        : btou
                                }
                            </Card.Footer>
                        </Card></Col>
                        )
                    }
                    // console.log("This is count ",count,r.accepted);
                    // console.log("This is notifi", r);

                })
            }
            let nav = ''
            if (this.state.typeofuser !== 'Retailer')
                nav = <Nav.Link eventKey={1} href="" onClick={this.adddmediHandler}>Add Medicine</Nav.Link>
            else {
                nav = <Nav.Link eventKey={1} href="" onClick={this.adddmediHandler}>Sell Medicine</Nav.Link>
            }
            if (this.state.typeofuser === 'Distributer')
                nav = ''
            var noN = ''
            let nav1 = ''
            // if (this.state.typeofuser !== 'Manufacturer')
            nav1 = <Nav.Link eventKey={4} href="" onClick={this.notifiHandler}>Notification
                   {
                    count === 0 ?
                        <sup style={{ fontWeight: 550, color: 'red', fontSize: 16 }}>{noN} </sup>
                        : <sup style={{ fontWeight: 550, color: 'red', fontSize: 15 }}>{count} </sup>

                }
            </Nav.Link>

            return (

                <div className="mainhomediv">
                    <Navbar collapseOnSelect expand="lg" bg="dark" variant="dark">
                        <Navbar.Brand href="" className="IconS">Medicare</Navbar.Brand>
                        <Navbar.Toggle aria-controls="responsive-navbar-nav" />
                        <Navbar.Collapse id="responsive-navbar-nav">
                            <Nav className="mr-auto">

                            </Nav>
                            <Nav>
                                {nav}
                                <Nav.Link eventKey={2} href="" onClick={this.mytryHandler}>
                                    My Transaction
                            </Nav.Link>
                                {nav1}
                                <Nav.Link eventKey={3} href="/" style={{ 'color': 'white', fontWeight: 550 }} onClick={this.logout}>LogOut <FiLogOut style={{ fontSize: 20, marginBottom: 3 }} /></Nav.Link>
                            </Nav>
                        </Navbar.Collapse>
                    </Navbar>


                    {

                        this.state.mytry === true ?
                            <Container style={{ marginTop: 50 }}>
                                <Row>
                                    <Col sm>
                                        {/* <input type="text" name='Name' className="searchinput speclassi" placeholder="Enter Transaction Id" onChange={this.handleChange} style={{ float: 'left', textIndent: 8 }}></input><GoSearch style={{ float: 'left', marginTop: 10, marginLeft: -30, fontSize: 22, opacity: 0.8 }} /><br /><br /> */}
                                        {sb}
                                    </Col>
                                    <Col sm>
                                        <span className="WelcomeUser">Welcome {this.state.typeofuser} {this.state.accountName.toUpperCase()}</span>
                                    </Col>
                                </Row>

                                <br />
                                <br />

                                <Row>
                                    {disp}
                                </Row>

                            </Container> : null

                    }



                    {
                        this.state.addmedi === true ?

                            this.state.typeofuser == 'Manufacturer' ?
                                <Container style={{ marginTop: 50 }} className="addmedi">
                                    <Row className="addmedirow">
                                        <Col sm={3} >
                                            <span className="addmediformspan">Medicine Name:</span>
                                        </Col>
                                        <Col sm={9}>
                                            <input type="text" name='medname' required onChange={this.handleChange} style={{ textIndent: 10 }} /><br /><br />
                                        </Col>
                                    </Row>

                                    <Row className="addmedirow">
                                        <Col sm={3} >
                                            <span className="addmediformspan">Start Id:</span>
                                        </Col>
                                        <Col sm={9}>
                                            <input type="text" name='maxeid' required value={this.state.maxeid} style={{ textIndent: 10 }} placeholder="Fetching id for you..........." /><br /><br />
                                        </Col>
                                    </Row>
                                    <Row className="addmedirow">
                                        <Col sm={3} >
                                            <span className="addmediformspan">End Id:</span>
                                        </Col>
                                        <Col sm={9}>
                                            <input type="text" name='eid' required onChange={this.handleChange} style={{ textIndent: 10 }} placeholder="Must be greater than Start id" /><br /><br />
                                        </Col>
                                    </Row>

                                    <Row className="addmedirow">
                                        <Col sm={3} >
                                            <span className="addmediformspan"> Distributer Address :</span>
                                        </Col>
                                        <Col sm={9}>
                                            <input type="text" name='to' required onChange={this.handleChange} style={{ textIndent: 10 }} /><br /><br />
                                        </Col>
                                    </Row>

                                    <Row className="addmedirow">
                                        <Col sm={3} >
                                            <span className="addmediformspan">Distributer Name:</span>
                                        </Col>
                                        <Col sm={9}>
                                            <input type="text" name='toname' required onChange={this.handleChange} style={{ textIndent: 10 }} /><br /><br />
                                        </Col>
                                    </Row>
                                    <Row className="addmedirow">
                                        <Col sm={3} >
                                            <span className="addmediformspan">Expiry date(in days):</span>
                                        </Col>
                                        <Col sm={9}>
                                            <input type="text" name='expire' required onChange={this.handleChange} style={{ textIndent: 10 }} /><br /><br />
                                        </Col>
                                    </Row>


                                    <Row className="addmedirow">
                                        <Col sm={3} >
                                        </Col>
                                        <Col sm={9}>
                                            <Button variant="outline-primary" className="addmedibutt" onClick={this.addmed}>Add This Medicine</Button>
                                        </Col>

                                    </Row>

                                    <br />

                                </Container>



                                : this.state.typeofuser == 'Distributer' ?
                                    <Container style={{ marginTop: 50 }} className="addmedi"> <Row className="addmedirow">
                                        <Col sm={3} >
                                            <span className="addmediformspan">Start Id:</span>
                                        </Col>
                                        <Col sm={9}>
                                            <input type="text" name='sid' required onChange={this.handleChange} value={this.state.sid} style={{ textIndent: 10 }} /><br /><br />
                                        </Col>
                                    </Row>
                                        <Row className="addmedirow">
                                            <Col sm={3} >
                                                <span className="addmediformspan">End Id:</span>
                                            </Col>
                                            <Col sm={9}>
                                                <input type="text" name='eid' required onChange={this.handleChange} placeholder={this.state.showeid} style={{ textIndent: 10 }} /><br /><br />
                                            </Col>
                                        </Row>

                                        <Row className="addmedirow">
                                            <Col sm={3} >
                                                <span className="addmediformspan"> Retailer Address {
                                                    console.log(this.state)}:</span>
                                            </Col>
                                            <Col sm={9}>
                                                <input type="text" name='to' required onChange={this.handleChange} style={{ textIndent: 10 }} /><br /><br />
                                            </Col>
                                        </Row>

                                        <Row className="addmedirow">
                                            <Col sm={3} >
                                                <span className="addmediformspan">Retailer Name:</span>
                                            </Col>
                                            <Col sm={9}>
                                                <input type="text" name='toname' required onChange={this.handleChange} style={{ textIndent: 10 }} /><br /><br />
                                            </Col>
                                        </Row>

                                        <Row className="addmedirow">
                                            <Col sm={3} >
                                            </Col>
                                            <Col sm={9}>
                                                <Button variant="outline-primary" className="addmedibutt" onClick={this.addmed}>Add This Medicine</Button>
                                            </Col>
                                        </Row></Container>


                                    : this.state.typeofuser == 'Retailer' ?
                                        <Container style={{ marginTop: 50 }} className="addmedi"> <Row className="addmedirow"></Row>
                                            <Row className="addmedirow">
                                                <Col sm={3} >
                                                    <span className="addmediformspan">Med Id</span>
                                                </Col>
                                                <Col sm={9}>
                                                    <input type="text" name='sid' required value={this.state.sid} onChange={this.handleChange} style={{ textIndent: 10 }} placeholder="Click on Forward From Notification to sell" /><br /><br />
                                                </Col>
                                            </Row>

                                            <Row className="addmedirow">
                                                <Col sm={3} >
                                                </Col>
                                                <Col sm={9}>
                                                    <Button variant="outline-primary" className="addmedibutt" onClick={this.addmed}>Sell Medicine</Button>
                                                </Col>
                                            </Row></Container> : null


                            : null
                    }




                    {

                        this.state.notifi === true ?
                            <Container style={{ marginTop: 50 }}>

                                <Row>

                                    {/* <Col sm={3}> */}
                                    {notif}
                                    {/* </Col> */}


                                </Row>

                            </Container> : null

                    }


                </div>

            );
        }
    }
}

export default withAuth(Home)