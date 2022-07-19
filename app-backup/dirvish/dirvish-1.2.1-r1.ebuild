# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Dirvish is a fast, disk based, rotating network backup system"
HOMEPAGE="http://www.dirvish.org/"
SRC_URI="http://dirvish.org/${P}.tgz"

LICENSE="OSL-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	dev-perl/Time-ParseDate
	dev-perl/Time-Period
	net-misc/rsync
"
BDEPEND="app-arch/tar"

src_prepare() {
	default

	local file
	for file in dirvish dirvish-runall dirvish-expire dirvish-locate; do
		cat > ${file}  <<-EOF || die
		#!${EPREFIX}/usr/bin/perl

		\$CONFDIR = "${EPREFIX}/etc/dirvish";

		EOF
		cat ${file}.pl >> ${file} || die
		cat loadconfig.pl >> ${file} || die
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
