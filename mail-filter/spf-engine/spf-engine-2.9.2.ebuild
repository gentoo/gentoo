# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 python3_8 )

# The built-in ipaddress module handles the parsing of IP addresses. If
# python is built without ipv6 support, then ipaddress can't parse ipv6
# addresses, and the daemon will crash if it sees an ipv6 SPF record. In
# other words, it's completely broken.
PYTHON_REQ_USE="ipv6"

# setup.py defines entry_points
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Policy daemon and milter for Postfix SPF verification"
HOMEPAGE="https://launchpad.net/spf-engine"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pyspf[${PYTHON_USEDEP}]"

RDEPEND="${DEPEND}
	dev-python/authres[${PYTHON_USEDEP}]"

DOCS=( CHANGES policyd-spf.conf.commented README README.per_user_whitelisting )

python_prepare_all() {
	# The "real" config file mentions the commented one, so we point
	# users in the right direction.
	local oldconf="policyd-spf.conf.commented"
	local newconf="/usr/share/doc/${PF}/${oldconf}"

	sed -e "1 s~ ${oldconf}~,\n#  ${newconf}~" -i policyd-spf.conf \
		|| die 'failed to update commented config file path'

	distutils-r1_python_prepare_all
}

src_install() {
	distutils-r1_src_install

	# Remove the milter files that are installed by default. The milter
	# isn't quite ready:
	#
	#   * The README says it's experimental not well-tested.
	#   * There's no documentation for its configuration parameters
	#     (expecially the UserID).
	#   * The configuration file is hard-coded to /usr/local.
	#   * The paths in the systemd service file are hard-coded to /usr/local.
	#   * We need to write an OpenRC service script for it.
	#
	# These are all eventually doable, but I'm not willing to commit to
	# making the milter work before upstream is.
	#
	rm "${ED}/usr/bin/pyspf-milter" \
		|| die "failed to remove ${ED}/usr/bin/pyspf-milter"
	rm -r "${ED}/usr/lib/systemd" \
		|| die "failed to remove ${ED}/usr/lib/systemd"
	rm -r "${ED}/usr/etc/init.d" \
		|| die "failed to remove ${ED}/usr/etc/init.d"
	einfo "The milter component of spf-engine is still deemed experimental"
	einfo "and not well-tested by upstream. It's missing configuration"
	einfo "files, service scripts, and documentation. In other words, it"
	einfo "doesn't work yet."

	# The setuptools installation routing always works relative to
	# python's prefix, so that when installing locally you wind up
	# with paths like /usr/local/etc. However for system installs
	# that does the wrong thing and puts the sysconfdir at /usr/etc.
	# Here we move it to the right place.
	mv -v "${ED}/usr/etc" "${ED}/" || die 'failed to relocate sysconfdir'
}
