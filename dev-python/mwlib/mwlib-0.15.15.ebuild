# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mwlib/mwlib-0.15.15.ebuild,v 1.4 2015/04/08 08:05:29 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 user

DESCRIPTION="Tools for parsing Mediawiki content to other formats"
HOMEPAGE="http://code.pediapress.com/code/ http://pypi.python.org/pypi/mwlib https://github.com/pediapress/mwlib/"
SRC_URI="https://github.com/pediapress/mwlib/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc server test"

RDEPEND="dev-python/lxml[${PYTHON_USEDEP}]
	>=dev-python/odfpy-0.9[${PYTHON_USEDEP}]
	<dev-python/odfpy-0.10[${PYTHON_USEDEP}]
	>=dev-python/pyPdf-1.12[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-1.5.5[${PYTHON_USEDEP}]
	<dev-python/pyparsing-1.6[${PYTHON_USEDEP}]
	>=dev-python/timelib-0.2[${PYTHON_USEDEP}]
	virtual/latex-base
	>=dev-python/simplejson-2.3[${PYTHON_USEDEP}]
	dev-python/gevent[${PYTHON_USEDEP}]
	>=dev-python/bottle-0.10[${PYTHON_USEDEP}]
	>=dev-python/apipkg-1.2[${PYTHON_USEDEP}]
	>=dev-python/qserve-0.2.7[${PYTHON_USEDEP}]
	dev-python/roman[${PYTHON_USEDEP}]
	>=dev-python/py-1.4[${PYTHON_USEDEP}]
	dev-python/sqlite3dbm[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	server? ( app-admin/sudo )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	app-arch/unzip
	dev-util/re2c
	dev-python/cython[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( >=dev-python/wsgiintercept-0.6[${PYTHON_USEDEP}] )"

# TODO: requires ploticus to generate timelines

DOCS=(changelog.rst)

pkg_setup() {
	if use server ;  then
		enewgroup mwlib
		enewuser mwlib -1 -1 -1 mwlib
	fi
}

python_prepare_all() {
	# mwlib.apipkg is actually used.
	sed -e 's/, "apipkg"//' -i setup.py || die

	# Execute odflint script.
	sed \
		-e "/def _get_odflint_module():/,/odflint =	_get_odflint_module()/d" \
		-e "s/odflint.lint(path)/os.system('odflint %s' % path)/" \
		-i tests/test_odfwriter.py || die

	# Disable test which requires installed mw-zip or mw-render script
	# which don't get generated in distutils_install_for_testing for some reason
	rm -f tests/test_{nuwiki,redirect,render,zipwiki}.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	if [[ ${EPYTHON} == python2* ]] ; then
		local CFLAGS="${CFLAGS} -fno-strict-aliasing"
		export CFLAGS
	fi

	distutils-r1_python_compile
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	distutils_install_for_testing
	PATH="${TEST_DIR}/scripts:${PATH}" py.test || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all

	if use server ; then
		keepdir /var/log/mwlib
		keepdir /var/cache/mwlib

		fowners mwlib:mwlib /var/log/mwlib /var/cache/mwlib
		fperms 0750 /var/log/mwlib /var/cache/mwlib

		insinto /etc/logrotate.d
		for d in mw-qserve nserve ; do
			newins "${FILESDIR}/${d}.logrotate" "${d}"
			newinitd "${FILESDIR}/${d}.initd" "${d}"
			newconfd "${FILESDIR}/${d}.confd" "${d}"
		done

		newins "${FILESDIR}/nslave.logrotate" "nslave"
		newinitd "${FILESDIR}/nslave.initd-r1" "nslave"
		newconfd "${FILESDIR}/nslave.confd-r1" "nslave"

		newins "${FILESDIR}/postman.logrotate" "postman"
		newinitd "${FILESDIR}/postman.initd-r1" "postman"
		newconfd "${FILESDIR}/postman.confd" "postman"

		insinto /etc/cron.d
		newins "${FILESDIR}/mwlib-purge-cache.cron-r1" "mwlib-purge-cache"
	else
		rm "${D}"/usr/bin/{mw-qserve,nserve,nslave,postman}* || die "removing binaries failed"
	fi
}

pkg_postinst() {
	elog "Please enable required image formats for dev-python/pillow"
	if use server ; then
		elog "A cronjob to cleanup the cache files got installed to"
		elog "  /etc/cron.d/mwlib-purge-cache"
		elog "Default parameters are to clean every 24h, adjust it to your needs."
	fi
}
