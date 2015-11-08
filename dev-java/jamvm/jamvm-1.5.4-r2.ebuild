# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils flag-o-matic multilib java-vm-2 autotools

DESCRIPTION="An extremely small and specification-compliant virtual machine"
HOMEPAGE="http://jamvm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug libffi"

CLASSPATH_SLOT=0.98
DEPEND="dev-java/gnu-classpath:${CLASSPATH_SLOT}
	libffi? ( virtual/libffi )
	amd64? ( virtual/libffi )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/"${P}-classes-location.patch"
)

src_prepare() {
	# without this patch, classes.zip is not found at runtime
	epatch "${PATCHES[@]}"
	eautoreconf

	# These come precompiled.
	# configure script uses detects the compiler
	# from PATH. I guess we should compile this from source.
	# Then just make sure not to hit
	# https://bugs.gentoo.org/show_bug.cgi?id=163801
	#rm -v lib/classes.zip || die
}

CLASSPATH_DIR="/usr/gnu-classpath-${CLASSPATH_SLOT}"

src_configure() {
	# Keep libjvm.so out of /usr
	# https://bugs.gentoo.org/show_bug.cgi?id=181896
	INSTALL_DIR="/usr/$(get_libdir)/${PN}"

	filter-flags "-fomit-frame-pointer"

	if use amd64 || use libffi; then
		append-cflags "$(pkg-config --cflags-only-I libffi)"
	fi

	local fficonf="--enable-ffi"
	use !amd64 && fficonf="$(use_enable libffi ffi)"

	econf ${fficonf} \
		--disable-dependency-tracking \
		$(use_enable debug trace) \
		--prefix=${INSTALL_DIR} \
		--datadir=/usr/$(get_libdir) \
		--bindir=/usr/bin \
		--libdir=${INSTALL_DIR}/lib \
		--with-classpath-install-dir=${CLASSPATH_DIR}
}

create_launcher() {
	local script="${D}/${INSTALL_DIR}/bin/${1}"
	cat > "${script}" <<-EOF
		#!/bin/sh
		exec /usr/bin/jamvm \
			-Xbootclasspath/p:"${CLASSPATH_DIR}/share/classpath/tools.zip" \
			gnu.classpath.tools.${1}.Main "\$@"
	EOF
	chmod +x "${script}"
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc ACKNOWLEDGEMENTS AUTHORS ChangeLog NEWS README

	set_java_env "${FILESDIR}/${P}-env.file"

	dosym /usr/bin/jamvm ${INSTALL_DIR}/bin/java
	dosym ${CLASSPATH_DIR}/share/classpath/glibj.zip ${INSTALL_DIR}/jre/lib/rt.jar
	dosym ${CLASSPATH_DIR}/share/classpath/tools.zip ${INSTALL_DIR}/lib/tools.jar
	for file in ${CLASSPATH_DIR}/bin/*; do
		base=$(basename ${file})
		create_launcher ${base#g}
	done
}
