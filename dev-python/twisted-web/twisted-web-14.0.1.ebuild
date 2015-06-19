# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-web/twisted-web-14.0.1.ebuild,v 1.1 2014/11/12 03:51:12 idella4 Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit twisted-r1

MY_PN="TwistedWeb"
DESCRIPTION="Twisted web server, programmable in Python"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="soap"

DEPEND="=dev-python/twisted-core-${TWISTED_RELEASE}*[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
	soap? ( dev-python/soappy[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

python_prepare_all() {
	if [[ "${EUID}" -eq 0 ]]; then
		# Disable tests failing with root permissions.
		sed -e "s/test_forbiddenResource/_&/" -i twisted/web/test/test_static.py
		sed -e "s/testDownloadPageError3/_&/" -i twisted/web/test/test_webclient.py
	fi

	distutils-r1_python_prepare_all
}
# testsuite has a PYTHONPATH oddity, currently appears to require a system install to effectively import,
# putting in question as to whether it is a testsuite
