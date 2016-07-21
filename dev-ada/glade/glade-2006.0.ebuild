# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit gnat

IUSE=""

DESCRIPTION="An implementation of the Distributed Systems Annex for the GNAT compiler"
HOMEPAGE="http://libre2.adacore.com/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="=virtual/ada-1995*"
RDEPEND="${DEPEND}"

# temporary install pool
DN="${WORKDIR}/LocalD"

src_unpack() {
	unpack ${A}

	cd "${S}"
	# configure performs some stupid check and in a wrong way, we will surely
	# have a modern enough gnat
	sed -i -e "s:-le \"\$am_gnatls_date\":-le \"20040909\":" configure
}

lib_compile()
{
	econf --with-optimization="${CFLAGS}" || die "econf failed"
	emake || die "make failed"
	einfo "lib_compile completed"
}

# NOTE: we are using $1 - the passed gnat profile name
lib_install()
{
	# This package expands the libs and sources provided by compiler. Therefore
	# we install in yet another local location, to bypass gnat's automation.
	# The compiler specific stuf is then moved to ${D} directly.  Not ideal, as
	# this hook is called from within src_compile, but alternatives are more
	# complex. The next version should probably be done mirroring the asis-xxx.
	make prefix="${DN}" \
		bindir="${DN}"/$(get_gnat_value PATH) \
		install || die "make install failed"
	#
	# Makefile does not seem to accept much more than bindir, so the rest we
	# will move manually
	local Gnat_Libdir=$(get_gnat_value ADA_OBJECTS_PATH)
	local Gnat_Incdir=$(get_gnat_value ADA_INCLUDE_PATH)
	mkdir -p "${DN}/${Gnat_Libdir}"
	mv "${DN}/lib/garlic"/*.ali "${DN}/lib/garlic"/libgarlic.a "${DN}/${Gnat_Libdir}"

	mkdir -p "${DN}/${Gnat_Incdir}"
	mv "${DN}/lib/garlic"/*.ad? "${DN}/${Gnat_Incdir}"
	rm -rf "${DN}/lib"

	# remove files already provided by compiler
	pushd "${DN}"
	for fn in "${Gnat_Libdir:1}"/*.ali "${Gnat_Incdir:1}"/*.ad?; do
		#  Gnat_Lib/Incdir are global, need to remove leading /
		if [[ -e /${fn} ]]; then
			rm -f ${fn}
		fi
	done
	popd
}

src_install ()
{
	# library is installed into the corresponding gnat, no extra env setting
	# necessary
	echo "" > ${LibEnv}

	gnat_src_install

	# clean empty dirs
	rm -rf "${D}"/usr/share/gnat/ "${D}"/usr/lib/ada/

	# move prepared stuff over
	cp -rp "${DN}"/* "${D}"
	dodoc README NEWS
	insinto /usr/share/doc/${PF}
	doins -r  Examples/
}

pkg_postinst() {
	echo
	elog "GLADE has been installed at the gnat compiler location, expanding	System Library."
	elog "No further configuration is necessary. Enjoy."
	echo
}
