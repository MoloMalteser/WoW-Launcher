extends Node

# Icon Generator Script
# Generates a proper application icon for the Arctium WoW Launcher

func _ready():
	generate_application_icon()

func generate_application_icon():
	# Create a 256x256 icon
	var icon_size = 256
	var image = Image.new()
	image.create(icon_size, icon_size, false, Image.FORMAT_RGBA8)
	
	# Fill with transparent background
	image.fill(Color(0, 0, 0, 0))
	
	# Create the icon design
	_draw_icon_design(image, icon_size)
	
	# Save the icon
	var texture = ImageTexture.new()
	texture.set_image(image)
	
	# Save to file
	var error = image.save_png("res://assets/icon.png")
	if error == OK:
		print("Application icon generated successfully!")
	else:
		print("Failed to save application icon")

func _draw_icon_design(image: Image, size: int):
	# Create a modern, professional icon design
	
	# Background circle
	var center = Vector2(size / 2, size / 2)
	var radius = size * 0.4
	
	# Draw background circle with gradient
	_draw_circle_gradient(image, center, radius, Color(0.1, 0.1, 0.15, 1.0), Color(0.2, 0.2, 0.3, 1.0))
	
	# Draw outer ring
	_draw_circle_outline(image, center, radius, Color(0.4, 0.6, 0.9, 1.0), 4)
	
	# Draw inner circle
	var inner_radius = radius * 0.7
	_draw_circle_gradient(image, center, inner_radius, Color(0.15, 0.15, 0.2, 1.0), Color(0.25, 0.25, 0.35, 1.0))
	
	# Draw "A" letter (for Arctium)
	_draw_letter_a(image, center, inner_radius * 0.6)
	
	# Draw decorative elements
	_draw_decorative_elements(image, center, radius)

func _draw_circle_gradient(image: Image, center: Vector2, radius: float, color1: Color, color2: Color):
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var pos = Vector2(x, y)
			var distance = pos.distance_to(center)
			
			if distance <= radius:
				var t = distance / radius
				var color = color1.lerp(color2, t)
				image.set_pixel(x, y, color)

func _draw_circle_outline(image: Image, center: Vector2, radius: float, color: Color, thickness: int):
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var pos = Vector2(x, y)
			var distance = pos.distance_to(center)
			
			if distance >= radius - thickness and distance <= radius:
				image.set_pixel(x, y, color)

func _draw_letter_a(image: Image, center: Vector2, size: float):
	# Draw a stylized "A" letter
	var points = [
		Vector2(0, size * 0.5),      # Top
		Vector2(-size * 0.4, -size * 0.4),  # Left
		Vector2(-size * 0.2, -size * 0.1),  # Left inner
		Vector2(size * 0.2, -size * 0.1),   # Right inner
		Vector2(size * 0.4, -size * 0.4),   # Right
		Vector2(0, -size * 0.2)     # Bottom
	]
	
	# Transform points to center
	for i in range(points.size()):
		points[i] += center
	
	# Draw the letter
	_draw_polygon(image, points, Color(0.9, 0.9, 1.0, 1.0))
	
	# Draw outline
	_draw_polygon_outline(image, points, Color(0.7, 0.8, 1.0, 1.0), 2)

func _draw_polygon(image: Image, points: Array, color: Color):
	# Simple polygon filling (for demonstration)
	# In a real implementation, you'd use proper polygon filling algorithms
	
	# Draw lines between points
	for i in range(points.size()):
		var start = points[i]
		var end = points[(i + 1) % points.size()]
		_draw_line(image, start, end, color, 3)

func _draw_polygon_outline(image: Image, points: Array, color: Color, thickness: int):
	for i in range(points.size()):
		var start = points[i]
		var end = points[(i + 1) % points.size()]
		_draw_line(image, start, end, color, thickness)

func _draw_line(image: Image, start: Vector2, end: Vector2, color: Color, thickness: int):
	# Bresenham's line algorithm
	var x0 = int(start.x)
	var y0 = int(start.y)
	var x1 = int(end.x)
	var y1 = int(end.y)
	
	var dx = abs(x1 - x0)
	var dy = abs(y1 - y0)
	var sx = 1 if x0 < x1 else -1
	var sy = 1 if y0 < y1 else -1
	var err = dx - dy
	
	while true:
		# Draw pixel with thickness
		for tx in range(-thickness/2, thickness/2 + 1):
			for ty in range(-thickness/2, thickness/2 + 1):
				var px = x0 + tx
				var py = y0 + ty
				if px >= 0 and px < image.get_width() and py >= 0 and py < image.get_height():
					image.set_pixel(px, py, color)
		
		if x0 == x1 and y0 == y1:
			break
		
		var e2 = 2 * err
		if e2 > -dy:
			err -= dy
			x0 += sx
		if e2 < dx:
			err += dx
			y0 += sy

func _draw_decorative_elements(image: Image, center: Vector2, radius: float):
	# Draw some decorative elements around the icon
	
	# Draw small circles around the main icon
	var num_circles = 6
	for i in range(num_circles):
		var angle = (2 * PI * i) / num_circles
		var offset = Vector2(cos(angle), sin(angle)) * radius * 0.8
		var circle_center = center + offset
		var circle_radius = radius * 0.1
		
		_draw_circle_gradient(image, circle_center, circle_radius, 
			Color(0.3, 0.5, 0.8, 0.6), Color(0.1, 0.3, 0.6, 0.8))

func generate_icon_variants():
	# Generate different icon sizes for different platforms
	var sizes = [16, 32, 48, 64, 128, 256]
	
	for size in sizes:
		var image = Image.new()
		image.create(size, size, false, Image.FORMAT_RGBA8)
		image.fill(Color(0, 0, 0, 0))
		
		_draw_icon_design(image, size)
		
		var filename = "res://assets/icon_%dx%d.png" % [size, size]
		image.save_png(filename)
		print("Generated icon: ", filename)

func create_platform_icons():
	# Create platform-specific icon variants
	
	# Windows icon (ICO format would need external tools)
	generate_icon_variants()
	
	# Android adaptive icon
	_create_android_adaptive_icon()
	
	# iOS app icon
	_create_ios_app_icon()

func _create_android_adaptive_icon():
	# Create Android adaptive icon components
	var foreground = Image.new()
	foreground.create(108, 108, false, Image.FORMAT_RGBA8)
	foreground.fill(Color(0, 0, 0, 0))
	
	var center = Vector2(54, 54)
	_draw_icon_design(foreground, 108)
	
	foreground.save_png("res://assets/android_icon_foreground.png")
	
	# Background
	var background = Image.new()
	background.create(108, 108, false, Image.FORMAT_RGBA8)
	background.fill(Color(0.1, 0.1, 0.15, 1.0))
	background.save_png("res://assets/android_icon_background.png")

func _create_ios_app_icon():
	# Create iOS app icon
	var sizes = [20, 29, 40, 58, 60, 76, 80, 87, 120, 152, 167, 180, 1024]
	
	for size in sizes:
		var image = Image.new()
		image.create(size, size, false, Image.FORMAT_RGBA8)
		image.fill(Color(0, 0, 0, 0))
		
		_draw_icon_design(image, size)
		
		var filename = "res://assets/ios_icon_%dx%d.png" % [size, size]
		image.save_png(filename)