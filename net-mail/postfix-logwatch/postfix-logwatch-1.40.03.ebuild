# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A log analyzer for postfix"
HOMEPAGE="http://logreporters.sourceforge.net/"
SRC_URI="mirror://sourceforge/logreporters/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-lang/perl"

src_prepare() {
	# Replace the default config file location with ours.
	local cfg_default='/usr/local/etc/${progname_prefix}-logwatch.conf'
	local cfg_gentoo='/etc/${progname_prefix}-logwatch.conf';
	sed -i "s~${cfg_default}~${cfg_gentoo}~" ${PN} \
		|| die 'failed to update the default config location'
}

src_compile() {
	# The default make target just outputs instructions. We don't want
	# the user to see these, so we avoid the default emake.
	:
}

src_install() {
	dodoc Bugs Changes README ${PN}.conf-topn
	doman ${PN}.1
	dobin ${PN}
	insinto /etc
	doins ${PN}.conf
}
