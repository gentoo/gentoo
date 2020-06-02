# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

#RESTRICT="test" # requires running MongoDB server

DESCRIPTION="Flask support for MongoDB and with WTF model forms"
HOMEPAGE="https://pypi.org/project/flask-mongoengine/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/flask-0.8[${PYTHON_USEDEP}]
	>=dev-python/mongoengine-0.8[${PYTHON_USEDEP}]
	>=dev-python/flask-wtf-0.8.3[${PYTHON_USEDEP}]"

BDEPEND="${RDEPEND}
	test? (
		>=dev-db/mongodb-2.6.0
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/rednose[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_prepare_all() {
	# fix distutils sandbox violation due to missing test-deps in normal build
	#sed -i '/test_requirements/d' setup.py || die
	#remove coverage config
	sed -i -e '/cover-/d' setup.cfg || die
	sed -i -e 's:--cov=flask_mongoengine::' setup.cfg || die
	sed -i -e 's:--cov-config=setup.cfg::' setup.cfg || die
	distutils-r1_python_prepare_all
}

python_test() {
	# Yes, we need TCP/IP for that...
	local DB_IP=127.0.0.1
	local DB_PORT=27000

	export DB_IP DB_PORT

	local dbpath=${TMPDIR}/mongo.db
	local logpath=${TMPDIR}/mongod.log

	# Now, the hard part: we need to find a free port for mongod.
	# We're just trying to run it random port numbers and check the log
	# for bind errors. It shall be noted that 'mongod --fork' does not
	# return failure when it fails to bind.

	mkdir -p "${dbpath}" || die
	while true; do
		ebegin "Trying to start mongod on port ${DB_PORT}"

		LC_ALL=C \
		mongod --dbpath "${dbpath}" --nojournal \
			--bind_ip ${DB_IP} --port ${DB_PORT} \
			--unixSocketPrefix "${TMPDIR}" \
			--logpath "${logpath}" --fork \
		&& sleep 2

		# Now we need to check if the server actually started...
		if [[ ${?} -eq 0 && -S "${TMPDIR}"/mongodb-${DB_PORT}.sock ]]; then
			# yay!
			eend 0
			break
		elif grep -q 'Address already in use' "${logpath}"; then
			# ay, someone took our port!
			eend 1
			: $(( DB_PORT += 1 ))
			continue
		else
			eend 1
			eerror "Unable to start mongod for tests. See the server log:"
			eerror "	${logpath}"
			die "Unable to start mongod for tests."
		fi
	done

	local failed
	#https://jira.mongodb.org/browse/PYTHON-521, py2.[6-7] has intermittent failure with gevent
	#pushd "${BUILD_DIR}"/../ > /dev/null
	#if [[ "${EPYTHON}" == python3* ]]; then
	#	2to3 --no-diffs -w test
	#fi
	DB_PORT2=$(( DB_PORT + 1 )) DB_PORT3=$(( DB_PORT + 2 )) esetup.py test || failed=1

	mongod --dbpath "${dbpath}" --shutdown || die

	[[ ${failed} ]] && die "Tests fail with ${EPYTHON}"

	rm -rf "${dbpath}" || die
}

