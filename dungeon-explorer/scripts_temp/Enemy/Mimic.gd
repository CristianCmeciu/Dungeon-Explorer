extends Enemy
class_name Mimic

func attack():
	if timeStunned >0:
		timeStunned-=1
		wasStunned = true
		return 0
	return randi_range(2,3)
