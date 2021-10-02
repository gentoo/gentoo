# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A Python Object-Document-Mapper for working with MongoDB"
HOMEPAGE="https://github.com/MongoEngine/mongoengine/"
SRC_URI="https://github.com/MongoEngine/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-python/blinker[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-db/mongodb
		dev-python/mongomock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# TODO: investigate
		tests/document/test_indexes.py::TestIndexes::test_collation
		tests/document/test_indexes.py::TestIndexes::test_covered_index
		tests/document/test_indexes.py::TestIndexes::test_create_geohaystack_index
		# no $eval
		tests/queryset/test_queryset.py::TestQueryset::test_exec_js_query
		tests/queryset/test_queryset.py::TestQueryset::test_exec_js_field_sub
		tests/queryset/test_queryset.py::TestQueryset::test_item_frequencies_normalize
		tests/queryset/test_queryset.py::TestQueryset::test_item_frequencies_with_0_values
		tests/queryset/test_queryset.py::TestQueryset::test_item_frequencies_with_False_values
		tests/queryset/test_queryset.py::TestQueryset::test_item_frequencies_with_null_embedded
		# TODO: investigate (wrong order? bad comparison?)
		tests/queryset/test_queryset.py::TestQueryset::test_distinct_ListField_EmbeddedDocumentField
	)

	local dbpath=${TMPDIR}/mongo.db
	local logpath=${TMPDIR}/mongod.log
	local DB_PORT=27017

	mkdir -p "${dbpath}" || die
	ebegin "Trying to start mongod on port ${DB_PORT}"

	LC_ALL=C \
	mongod --dbpath "${dbpath}" --nojournal \
		--bind_ip 127.0.0.1 --port ${DB_PORT} \
		--unixSocketPrefix "${TMPDIR}" \
		--logpath "${logpath}" --fork || die
	sleep 2

	# Now we need to check if the server actually started...
	if [[ -S "${TMPDIR}"/mongodb-${DB_PORT}.sock ]]; then
		# yay!
		eend 0
	else
		eend 1
		eerror "Unable to start mongod for tests. Here is the server log:"
		cat "${logpath}"
		die "Unable to start mongod for tests"
	fi

	local failed
	nonfatal epytest || failed=1

	mongod --dbpath "${dbpath}" --shutdown || die

	[[ ${failed} ]] && die "Tests fail with ${EPYTHON}"

	rm -rf "${dbpath}" || die
}
