extends Resource
class_name Human_Name_Generator

const LAST = ["Anderson","Brown","Davis","Jackson","Johnson","Jones","Lee","Martin","Miller","Moore","Smith","Taylor","Thomas","Thompson","White","Williams","Wilson"]
const MALE = ["Albert","Arthur","Charles","Clarence","David","Edward","Frank","Fred","George","Harry","Henry","James","Joe","John","Joseph","Louis","Randy","Robert","Samuel","Thomas","Walter","William"]
const FEMALE = ["Alice","Anna","Annie","Bertha","Bessie","Clara","Elizabeth","Ella","Emma","Ethel","Florence","Gardner","Grace","Ida","Laura","Mabel","Margaret","Martha","Mary","Minnie","Nellie","Sarah"]

static func random_last():
	return LAST.pick_random()

static func random_male():
	return MALE.pick_random()

static func random_female():
	return FEMALE.pick_random()
