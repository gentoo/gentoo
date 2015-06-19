# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/geant-python/geant-python-4.9.6_p02.ebuild,v 1.4 2015/04/08 18:23:27 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit python-r1 versionator multilib eutils

MYP="geant$(replace_version_separator 3 .)"

DESCRIPTION="Python bindings for Geant4"
HOMEPAGE="http://geant4.cern.ch/"
SRC_URI="http://geant4.cern.ch/support/source/${MYP}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="geant4"
SLOT="0"
IUSE="examples"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/boost[${PYTHON_USEDEP}]
	dev-libs/xerces-c
	=sci-physics/geant-${PV}*"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYP}/environments/g4py"

pkg_setup() {
	if use amd64; then
		ARG=linux64
	elif use x86; then
		ARG=linux
	else
		die "platform unknown"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.9.5-visverbose.patch
	sed -i -e "s/lib64/$(get_libdir)/g" configure || die
	sed -i -e 's/-lG4clhep/-lCLHEP/g' config/g4py.gmk || die
	# respect user toolchain and flags
	sed -i \
		-e '/^CXX.*:=/d' \
		-e '/CXXFLAGS/s/-f\(template-depth-255\|inline-functions\|permissive\)//g' \
		-e "/CXXFLAGS/s/-O2/${CXXFLAGS}/g" \
		-e '/^rpathflag/s|:\($(rpath.)\)| -Wl,-rpath,\1 |g' \
		-e "s/\$(rpathflag)/\$(LDFLAGS) \$(rpathflag)/g" \
		config/sys/linux* || die
	python_copy_sources

	run_sed() {
		sed -i -e "s/\(python_exe=\)python/\1${EPYTHON}/" configure || die
		[[ ${EPYTHON} == python3* ]] && sed -i -e "s/with_python3=0/with_python3=1/" configure
		# let Geant4 module installed into python sitedir instead of default
		sed -i \
			-e "/G4PY_LIBDIR  :=/cG4PY_LIBDIR  := $\(DESTDIR\)$(python_get_sitedir)/Geant4" \
			config/install.gmk || die "sed failed on config/install.gmk"

		local mfile
		for mfile in source/python{3,}/GNUmakefile
		do
			sed -i \
				-e "/install_dir :=/cinstall_dir := $\(DESTDIR\)$(python_get_sitedir)/Geant4" \
				"${mfile}" || die "sed failed on ${mfile}"
		done

		# let g4py module installed into python sitedir instead of default
		sed -i \
		-e "/install_dir :=/cinstall_dir := $\(DESTDIR\)$(python_get_sitedir)/g4py" \
			config/site-install.gmk || die "sed failed on config/site-install.gmk"
		for mfile in {processes/emcalculator,utils/MCScore}/{python3/,}GNUmakefile python/GNUmakefile
		do
			sed -i \
				-e "/install_dir :=/cinstall_dir := $\(DESTDIR\)$(python_get_sitedir)/g4py" \
				"site-modules/${mfile}" || die "sed failed on site-modules/${mfile}"
		done

	}
	python_foreach_impl run_in_build_dir run_sed
}

src_configure() {
	run_configure() {
		# not the autotools configure
		./configure ${ARG} \
			--prefix="${EPREFIX}/usr" \
			--with-g4install-dir="${EPREFIX}/usr" \
			--with-python-incdir="$(python_get_includedir)" \
			--with-python-libdir="${EPREFIX}/usr/$(get_libdir)" \
			--with-boost-incdir="${EPREFIX}/usr/include"  \
			--with-boost-libdir="${EPREFIX}/usr/$(get_libdir)" \
			--with-boost-python-lib="boost_python-${EPYTHON#python}" \
			--with-xercesc-incdir="${EPREFIX}/usr/include" \
			--with-xercesc-libdir="${EPREFIX}/usr/$(get_libdir)" \
			|| die "configure failed"
	}
	python_foreach_impl run_in_build_dir run_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir emake CPPVERBOSE=1
}

src_test() {
	run_test() {
		emake -C tests
	}
	python_foreach_impl run_in_build_dir run_test
}

src_install() {
	python_foreach_impl run_in_build_dir emake DESTDIR="${D}" install
	dodoc README.md History
	insinto /usr/share/doc/${PF}
	use examples && doins -r examples
}
