# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A log analyzer for postfix"
HOMEPAGE="http://logreporters.sourceforge.net/"
SRC_URI="mirror://sourceforge/logreporters/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

# >sys-apps/logwatch-7.4.0 ships our logwatch scripts and will
# thus obsolete this use flag.
IUSE="logwatch"

RDEPEND="dev-lang/perl
	logwatch? ( !>sys-apps/logwatch-7.4.0 )"

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
	# There are two different "versions" of the package in the
	# tarball: a standalone executable and a logwatch filter. The
	# standalone is always installed. However, the logwatch filter is
	# only installed with USE="logwatch".
	dodoc Bugs Changes README ${PN}.conf-topn
	doman ${PN}.1
	dobin ${PN}
	insinto /etc
	doins ${PN}.conf

	if use logwatch; then
		# Remove the taint mode (-T) switch from the header of the
		# standalone executable, and save the result as our logwatch
		# filter.
		#
		# We don't do this for the standalone script because it's nice
		# to have the taint flag when it works.
		#
		sed 's~^#!/usr/bin/perl -T$~#!/usr/bin/perl~' ${PN} > postfix \
			|| die 'failed to remove the perl taint switch'

		insinto /etc/logwatch/scripts/services
		doins postfix

		insinto /etc/logwatch/conf/services
		newins ${PN}.conf postfix.conf
	fi
}
