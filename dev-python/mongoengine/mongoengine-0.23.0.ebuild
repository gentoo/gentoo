# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="A Python Object-Document-Mapper for working with MongoDB"
HOMEPAGE="https://github.com/MongoEngine/mongoengine/"
SRC_URI="https://github.com/MongoEngine/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO: make it run a local database server
#RESTRICT="test"

RDEPEND="dev-python/blinker[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]"
BDEPEND="
	test? ( dev-python/mongomock[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

src_prepare() {
	# TODO: investigate
	sed -e 's:test_covered_index:_&:' \
		-i tests/document/test_indexes.py || die
	# no $eval
	sed -e 's:test_exec_js_field_sub:_&:' \
		-e 's:test_exec_js_query:_&:' \
		-e 's:test_item_frequencies_normalize:_&:' \
		-e 's:test_item_frequencies_with_0_values:_&:' \
		-e 's:test_item_frequencies_with_False_values:_&:' \
		-e 's:test_item_frequencies_with_null_embedded:_&:' \
		-i tests/queryset/test_queryset.py || die
	# TODO: investigate (wrong order? bad comparison?)
	sed -e 's:test_distinct_ListField_EmbeddedDocumentField:_&:' \
		-i tests/queryset/test_queryset.py || die

	distutils-r1_src_prepare
}
