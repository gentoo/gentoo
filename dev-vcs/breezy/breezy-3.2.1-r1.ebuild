# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1 optfeature

DESCRIPTION="Distributed Version Control System with a Friendly UI"
HOMEPAGE="https://www.breezy-vcs.org/ https://github.com/breezy-team/breezy"
SRC_URI="https://launchpad.net/brz/$(ver_cut 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Most tests don't need tests, but deselecting those that need is too hard
RESTRICT="test"
PROPERTIES="test_network"

RDEPEND="
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/dulwich[${PYTHON_USEDEP}]
	dev-python/fastimport[${PYTHON_USEDEP}]
	dev-python/patiencediff[${PYTHON_USEDEP}]
	!dev-vcs/bzr
"
BDEPEND="
	sys-devel/gettext
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		app-crypt/gpgme[python,${PYTHON_USEDEP}]
		dev-python/paramiko[${PYTHON_USEDEP}]
		dev-python/pycryptodome[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/subunit[${PYTHON_USEDEP}]
		' python3_{8,9})
	)
"

distutils_enable_tests --install unittest

src_prepare() {
	distutils-r1_src_prepare
	# Fix man instal location
	sed -e '/DATA_FILES/s/man\//share\/&/' -i setup.py || die

	# Fix call to unittest's stuff
	grep -r breezy -le 'loadTestsFromModuleNames' | xargs sed -i -e 's/loadTestsFromModuleNames/loadTestsFromNames/' || die

	# Very horrible, looks like too much, but only ~250 tests out of ~30,000.
	# Before every bump, check the need for every disable, using direct test
	# for only a specific file.
	# Don't disable tests by removing files, as this results in bad imports.
	sed -e 's/test_bzr_connect_to_bzr_ssh/_&/' -i breezy/tests/test_transport.py || die
	sed -e 's/test_is_compatible_and_registered/_&/' \
		-e 's/test_make_repository/_&/' -i breezy/plugins/weave_fmt/test_repository.py || die
	sed -e 's/test_server_exception_with_hook/_&/' -i breezy/tests/blackbox/test_serve.py || die
	sed -e 's/test_dump_/_&/' -i breezy/bzr/tests/blackbox/test_dump_btree.py || die
	sed -e 's/test_/_&/' -i breezy/plugins/fastimport/tests/test_head_tracking.py || die

	sed -e '/test_vfs_ratchet/d' -i breezy/bzr/tests/__init__.py || die
	sed -e '/test_blackbox/d' -i breezy/git/tests/__init__.py || die
	sed -e '/test_upload/d' -i breezy/plugins/upload/tests/__init__.py || die
	sed -e '/test_bzrdir/d' -i breezy/plugins/weave_fmt/__init__.py || die
	sed -e '/test_big_file/d' -i breezy/tests/blackbox/__init__.py || die
	sed -e '/breezy.tests.test_gpg/d' \
		-e '/breezy.tests.test_plugins/d' \
		-e '/breezy.tests.test_source/d' \
		-i breezy/tests/__init__.py || die
}

src_install() {
	distutils-r1_src_install

	# Symlink original bzr's bin names to new names
	dosym brz /usr/bin/bzr
}

pkg_postinst() {
	optfeature "access branches over sftp" "dev-python/pycryptodome dev-python/paramiko"
	optfeature "PGP sign and verify commits" "app-crypt/gpgme[python]"
}
