# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="git://github.com/openSUSE/obs-build.git"

if [[ "${PV}" == "9999" ]]; then
	EXTRA_ECLASS="git-2"
else
	OBS_PACKAGE="build"
	OBS_PROJECT="openSUSE:Tools"
	EXTRA_ECLASS="obs-download"
fi

inherit eutils ${EXTRA_ECLASS}
unset EXTRA_ECLASS

DESCRIPTION="Script to build SUSE Linux RPMs"
HOMEPAGE="https://build.opensuse.org/package/show/openSUSE:Tools/build"

[[ "${PV}" == "9999" ]] || SRC_URI="${OBS_URI}/${PN/suse/obs}-${PV//.}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="symlink"
[[ "${PV}" == "9999" ]] || \
KEYWORDS="amd64 x86"

RDEPEND="
	virtual/perl-Digest-MD5
	virtual/perl-Getopt-Long
	dev-perl/XML-Parser
	dev-perl/TimeDate
	app-shells/bash
	app-arch/cpio
	app-arch/rpm
"

S="${WORKDIR}/${PN/suse/obs}-${PV//.}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-libexec-paths.patch
}

src_compile() { :; }

src_install() {
	emake DESTDIR="${ED}" pkglibdir=/usr/libexec/suse-build install
	cd "${ED}"/usr
	find bin -type l | while read i; do
		mv "${i}" "${i/bin\//bin/suse-}"
		use !symlink || dosym "${i/bin\//suse-}" "/usr/${i}"
	done
	find share/man/man1 -type f | while read i; do
		mv "${i}" "${i/man1\//man1/suse-}"
		use !symlink || dosym "${i/man1\//suse-}" "/usr/${i}"
	done

	# create symlink for default build config
	dosym /usr/libexec/suse-build/configs/sl13.2.conf /usr/libexec/suse-build/configs/default.conf
}
