import React, { Component } from 'react';
import AuthService from './AuthService/AuthService';

export default function withAuth(AuthComponent) {

    const Auth = new AuthService();
    return class AuthWrapped extends Component {
        constructor() {
            super();
            this.state = {
                user: { userName: null }
            }
        }
        componentWillMount() {
            if (!Auth.loggedIn()) {
                this.props.history.replace('/Login')
            }
            else {
                try {
                    const profile = Auth.getProfile()
                    this.setState({
                        user: profile
                    })
                }
                catch (err) {
                    Auth.logout()
                    this.props.history.replace('/Login')
                }
            }
        }
        render() {
            if (this.state.user.userName === 'admin') {
                return (

                    <AuthComponent history={this.props.history} user={this.state.user} />
                )
            }
            else {
                this.props.history.replace('/Login')
                return null
            }
        }
    }
}