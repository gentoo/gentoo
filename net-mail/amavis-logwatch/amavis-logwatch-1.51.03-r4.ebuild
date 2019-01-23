# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A log analyzer for amavisd-new"
HOMEPAGE="http://logreporters.sourceforge.net/"
SRC_URI="mirror://sourceforge/logreporters/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}/unescaped-left-brace.patch"
	"${FILESDIR}/redundant-argument-to-sprintf.patch"
	"${FILESDIR}/ignore-amavis-startup-notifications.patch"
	"${FILESDIR}/ignore-utf8smtp-lines.patch"
	"${FILESDIR}/unchecked-encrypted.patch"
	"${FILESDIR}/file-libmagic-errors.patch"
	"${FILESDIR}/ignore-all-sd_notify-lines.patch"
	"${FILESDIR}/no-pid_file-configured.patch"
	"${FILESDIR}/will-bind-to-lines.patch"
	"${FILESDIR}/SANITIZED-NULL-bytes-messages.patch"
)

src_prepare() {
	default
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
	dodoc Bugs Changes README
	doman ${PN}.1
	dobin ${PN}
	insinto /etc
	doins ${PN}.conf
}
