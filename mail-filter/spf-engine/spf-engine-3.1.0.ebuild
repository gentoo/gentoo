# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 python3_11 python3_12 python3_13 )

# The built-in ipaddress module handles the parsing of IP addresses. If
# python is built without ipv6 support, then ipaddress can't parse ipv6
# addresses, and the daemon will crash if it sees an ipv6 SPF record. In
# other words, it's completely broken.
PYTHON_REQ_USE="ipv6(+)"
DISTUTILS_USE_PEP517=flit
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="Policy daemon for Postfix SPF verification"
HOMEPAGE="https://launchpad.net/spf-engine"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv x86"

RDEPEND="dev-python/pyspf[${PYTHON_USEDEP}]
	dev-python/authres[${PYTHON_USEDEP}]"

DOCS=( CHANGES )

python_prepare_all() {
	distutils-r1_python_prepare_all

	# The tarball has a "data" directory containing a hierarchy that
	# flit wants to insert right into /usr. Before it does that, we have
	# to remove the parts we don't want, and fix some of the paths.
	#
	# Note that one of our patches already mangles a few of these
	# before we even see them.

	einfo "removing milter files"
	rm -v -r data/lib data/etc/init.d data/share/man/man8 || die
	rm -v data/etc/pyspf-milter/pyspf-milter.conf || die
	rm -v spf_engine/milter_spf.py || die

	# And don't create a python-exec wrapper for it.
	sed -e '/^pyspf-milter = /d' -i pyproject.toml || die

	# The commented conf example is documentation, not configuration.
	mv -v data/etc/python-policyd-spf/policyd-spf.conf.commented \
	   data/share/doc/python-policyd-spf/ || die

	# The man page hard-codes /usr/local/etc, it should be /etc.
	sed -e 's:/usr/local/etc:/etc:g' \
		-i data/share/man/man1/policyd-spf.1 || die

	# Fix the documentation path.
	mv -v data/share/doc/python-policyd-spf "data/share/doc/${PF}" || die

	# The "real" config file mentions the commented one, so we point
	# users in the right direction. Caveat: the documentation is
	# compressed, so we're usually off by a ".bz2" suffix anyway.
	local oldconf="policyd-spf.conf.commented"
	local newconf="/usr/share/doc/${PF}/${oldconf}"
	sed -e "1 s~ ${oldconf}~,\n#  ${newconf}~" \
		-i "data/etc/python-policyd-spf/policyd-spf.conf" \
		|| die 'failed to update commented config file path'
}

src_install() {
	distutils-r1_src_install

	# The "data" installation is relative to python's prefix, so
	# data/etc gets installed to /usr/etc. Let's fix that.
	mv -v "${ED}/usr/etc" "${ED}/" || die 'failed to relocate sysconfdir'
}
