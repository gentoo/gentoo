# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/pazz/alot/"
	inherit git-r3
else
	SRC_URI="https://github.com/pazz/alot/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Experimental terminal UI for net-mail/notmuch written in Python"
HOMEPAGE="https://github.com/pazz/alot"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-crypt/gpgme-1.9.0[python,${PYTHON_USEDEP}]
	>=dev-python/configobj-4.7.0[${PYTHON_USEDEP}]
	dev-python/python-magic[${PYTHON_USEDEP}]
	>=dev-python/urwid-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/urwidtrees-1.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-18.4[${PYTHON_USEDEP}]
	net-mail/mailbase
	>=net-mail/notmuch-0.27[crypt,python]
	"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
	)
	"

PATCHES=(
	"${FILESDIR}/${PV}-0001-remove-non-working-test.patch"
	)

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/build/html/. )
	fi
}

src_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/alot
	doins -r extra
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog ""
		elog "If you are new to Alot you may want to take a look at"
		elog "the user manual:"
		elog "   https://alot.readthedocs.io/en/latest/"
		elog ""
	else
		local rv
		for rv in ${REPLACING_VERSIONS} ; do
			if ver_test "${rv}" -le "0.5.1"; then
				ewarn ""
				ewarn "Since 0.6 version the GPG engine has switched to app-crypt/gpgme"
				ewarn "to use GPG signing operations, you can pass the key id has arg"
				ewarn "or setup the gpg_key value in your config file, see"
				ewarn "  https://alot.readthedocs.io/en/latest/usage/crypto.html?highlight=gpg"
				ewarn ""
				break
			fi
		done
	fi
}
