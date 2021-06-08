# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Flask support for MongoDB and with WTF model forms"
HOMEPAGE="https://pypi.org/project/flask-mongoengine/"
SRC_URI="
	https://github.com/MongoEngine/flask-mongoengine/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

RDEPEND=">=dev-python/flask-1.1.2[${PYTHON_USEDEP}]
	>=dev-python/mongoengine-0.20[${PYTHON_USEDEP}]
	>=dev-python/flask-wtf-0.14.3[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-db/mongodb
		dev-python/python-email-validator[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e '/addopts/d' setup.cfg || die

	# fails with mongomock installed
	sed -e 's:test_connection__should_parse_mongo_mock_uri:_&:' \
		-i tests/test_connection.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local dbpath=${TMPDIR}/mongo.db
	local logpath=${TMPDIR}/mongod.log

	mkdir -p "${dbpath}" || die
	ebegin "Trying to start mongod on port ${DB_PORT}"

	LC_ALL=C \
	mongod --dbpath "${dbpath}" --nojournal \
		--bind_ip 127.0.0.1 --port 27017 \
		--unixSocketPrefix "${TMPDIR}" \
		--logpath "${logpath}" --fork || die
	sleep 2

	# Now we need to check if the server actually started...
	if [[ -S "${TMPDIR}"/mongodb-27017.sock ]]; then
		# yay!
		eend 0
	else
		eend 1
		eerror "Unable to start mongod for tests. See the server log:"
		eerror "	${logpath}"
		die "Unable to start mongod for tests."
	fi

	local failed
	nonfatal epytest || failed=1

	mongod --dbpath "${dbpath}" --shutdown || die

	[[ ${failed} ]] && die "Tests fail with ${EPYTHON}"

	rm -rf "${dbpath}" || die
}
