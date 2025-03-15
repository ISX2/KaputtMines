extends RigidBody2D

var texture_region: Rect2
var tile_scale: Vector2

func setup(texture: Texture2D, region: Rect2, scale_factor: Vector2 = Vector2(1, 1)):
	# Set the sprite texture and region
	var sprite = $TileSprite
	sprite.texture = texture
	sprite.region_enabled = true
	sprite.region_rect = region
	
	# Apply scale
	scale = scale_factor
	
	# Update collision shape based on texture size and scale
	var collision = $Collision
	var shape = RectangleShape2D.new()

	collision.shape.set_size(Vector2(region.size.x * scale.x, region.size.y * scale.y))
	#collision.position = Vector2(region.size.x * scale.x, region.size.y* scale.y)
