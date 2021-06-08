# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit check-reqs distutils-r1

MY_P=mongo-python-driver-${PV}
DESCRIPTION="Python driver for MongoDB"
HOMEPAGE="https://github.com/mongodb/mongo-python-driver https://pypi.org/project/pymongo/"
SRC_URI="
	https://github.com/mongodb/mongo-python-driver/archive/${PV}.tar.gz
		-> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~hppa x86"
IUSE="doc kerberos test"
RESTRICT="!test? ( test )"

RDEPEND="
	kerberos? ( dev-python/pykerberos[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		>=dev-db/mongodb-2.6.0
		dev-python/nose[${PYTHON_USEDEP}]
	)
"
DISTUTILS_IN_SOURCE_BUILD=1

distutils_enable_sphinx doc

reqcheck() {
	if use test; then
		# During the tests, database size reaches 1.5G.
		local CHECKREQS_DISK_BUILD=1536M

		check-reqs_${1}
	fi
}

pkg_pretend() {
	reqcheck pkg_pretend
}

pkg_setup() {
	reqcheck pkg_setup
}

src_prepare() {
	# network-sandbox probably
	rm test/test_srv_polling.py || die
	sed -e 's:test_connection_timeout_ms_propagates_to_DNS_resolver:_&:' \
		-i test/test_client.py || die
	# relies on exact exception message
	sed -e 's:abstract methods:abstract:' \
		-i test/test_custom_types.py || die
	distutils-r1_src_prepare
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
	DB_PORT2=$(( DB_PORT + 1 )) DB_PORT3=$(( DB_PORT + 2 )) esetup.py test || failed=1

	mongod --dbpath "${dbpath}" --shutdown || die

	[[ ${failed} ]] && die "Tests fail with ${EPYTHON}"

	rm -rf "${dbpath}" || die
}
