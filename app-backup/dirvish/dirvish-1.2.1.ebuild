# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Dirvish is a fast, disk based, rotating network backup system"
HOMEPAGE="http://www.dirvish.org/"
SRC_URI="http://dirvish.org/${P}.tgz"

LICENSE="OSL-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="app-arch/tar"
RDEPEND="dev-perl/Time-ParseDate
	dev-perl/Time-Period
	>=net-misc/rsync-2.5.7"

src_prepare() {
	default

	local f
	for f in dirvish dirvish-runall dirvish-expire dirvish-locate; do
		cat > $f  <<-EOF || die
		#!/usr/bin/perl

		\$CONFDIR = "/etc/dirvish";

		EOF
		cat $f.pl >> $f || die
		cat loadconfig.pl >> $f || die
	done
}

src_install() {
	dosbin dirvish dirvish-runall dirvish-expire dirvish-locate
	doman dirvish.8 dirvish-runall.8 dirvish-expire.8 dirvish-locate.8 dirvish.conf.5

	HTML_DOCS=( {FAQ,RELEASE,TODO}.html )
	einstalldocs

	insinto /etc/dirvish
	doins "${FILESDIR}"/master.conf.example
}
