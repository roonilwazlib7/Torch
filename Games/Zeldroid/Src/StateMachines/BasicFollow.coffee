exports = this
class exports.BasicFollow
    sprite: null

    constructor: (@sprite) ->

        @machine = @sprite.States.CreateStateMachine("BasicFollow")
        @machine.AddState( "idle", new IdleState() )
        @machine.AddState( "follow", new FollowState() )

        @machine.Switch( "idle" )


class IdleState
    Start: (sprite) ->
        sprite.Body.velocity.MultiplyScalar(0)

    Execute: (sprite) ->
        distVec = @game.player.position.Clone()
        distVec.SubtractVector(sprite.position)
        if distVec.magnitude <= 500
            @stateMachine.Switch( "follow" )

    End: (sprite) ->

class FollowState
    Start: (sprite) ->

    Execute: (sprite) ->
        dir = sprite.position.Clone()
        dir.SubtractVector(@game.player.position)
        dir.Normalize()
        dir.MultiplyScalar(-1)

        followVelocity = 0.1

        sprite.Body.velocity.x = 0
        sprite.Body.velocity.y = 0

        if Math.abs(dir.x) >= Math.abs(dir.y)
            sprite.Body.velocity.x = followVelocity * Torch.Util.Math.Sign(dir.x)
        else
            sprite.Body.velocity.y = followVelocity * Torch.Util.Math.Sign(dir.y)

    End: (sprite) ->
