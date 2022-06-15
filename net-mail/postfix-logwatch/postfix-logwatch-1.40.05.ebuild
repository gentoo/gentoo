# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A log analyzer for postfix"
HOMEPAGE="http://michael.orlitzky.com/code/postfix-logwatch.xhtml"
SRC_URI="http://michael.orlitzky.com/code/releases/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/perl"

src_prepare() {
	default
	# Replace the default config file location with ours.
	local cfg_default='/usr/local/etc/${progname_prefix}-logwatch.conf'
	local cfg_gentoo='/etc/${progname_prefix}-logwatch.conf';
	sed -i "s~${cfg_default}~${cfg_gentoo}~" ${PN} \
		|| die 'failed to update the default config location'
}

src_install() {
	dodoc Bugs Changes README ${PN}.conf-topn
	doman ${PN}.1
	dobin ${PN}
	insinto /etc
	doins ${PN}.conf
}
