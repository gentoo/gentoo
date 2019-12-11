# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MYP=gnat-gpl-${PV}
DESCRIPTION="GNAT Ada suite"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="
	x86? ( http://mirrors.cdn.adacore.com/art/564b3e9dc8e196b040fbe248
		-> ${MYP}-x86-linux-bin.tar.gz )
	amd64? ( http://mirrors.cdn.adacore.com/art/564b3ebec8e196b040fbe66c
		-> ${MYP}-x86_64-linux-bin.tar.gz )"

LICENSE="GPL-2 GPL-3"
SLOT="${PV}"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-devel/binutils
	sys-devel/gdb"

S="${WORKDIR}"

PREFIX=/opt/${P}

src_prepare() {
	default
	cd ${MYP}-$(usex amd64 x86_64 x86)-linux-bin
	cd share/examples/gnat
	cat header.xml \
		full_project/full.xml \
		options/options.xml \
		other_languages/cpp_main/cpp_main.xml \
		other_languages/cpp_pragmas/cpp_pragmas.xml \
		other_languages/import_from_c/import_from_c.xml \
		plugins/plugins.xml \
		stream_io/stream_io.xml \
		simple_project/simple.xml \
		starter/starter.xml \
		xml_stream/xml_stream.xml \
		containers/anagram/anagram.xml \
		containers/genealogy/genealogy.xml \
		containers/hash/hash.xml \
		containers/library/library.xml \
		containers/shapes/shapes.xml \
		containers/spellcheck/spellcheck.xml \
		containers/wordcount/wordcount.xml \
		containers/wordfreq/wordfreq.xml \
		oo_interfaces/oo_interfaces.xml \
		oo_airline/oo_airline.xml \
		altivec/altivec.xml \
		footer.xml \
		> gnat-examples.xml \
		|| die
	sed -i \
		-e "s:PREFIX:${PREFIX}:" \
		gnat-examples.xml || die
	cd ../../..

	# Remove objects from binutils
	cd bin
	rm addr2line c++filt gprof objdump || die
	cd ..
	rm share/doc/gnat/info/{as,bfd,binutils,ld}.info || die
	rm lib*/libiberty.a || die

	# Remove objects from gdb
	cd bin
	rm gdb gdbserver gcore || die
	cd ..
	rm -r include/gdb || die
	rm lib*/libinproctrace.so || die
	rm -r share/gdb-* || die
	rm share/doc/gnat/info/gdb.info || die

	basever=4.7.4
	machine=$(usex amd64 x86_64 x86)-pc-linux-gnu
	rm libexec//gcc/${machine}/${basever}/ld || die
}

src_install() {
	cd ${MYP}-$(usex amd64 x86_64 x86)-linux-bin
	into ${PREFIX}
	dobin bin/*
	insinto ${PREFIX}
	doins -r etc include lib* share
	insinto ${PREFIX}/share/gps/plug-ins
	doins share/examples/gnat/gnat-examples.xml
	fperms 755 ${PREFIX}/libexec/gcc/${machine}/${basever}/cc1
	fperms 755 ${PREFIX}/libexec/gcc/${machine}/${basever}/cc1plus
	fperms 755 ${PREFIX}/libexec/gcc/${machine}/${basever}/collect2
	fperms 755 ${PREFIX}/libexec/gcc/${machine}/${basever}/gnat1
	fperms 755 ${PREFIX}/libexec/gcc/${machine}/${basever}/liblto_plugin.so.0.0.0
	fperms 755 ${PREFIX}/libexec/gcc/${machine}/${basever}/lto1
	fperms 755 ${PREFIX}/libexec/gcc/${machine}/${basever}/lto-wrapper
	fperms 755 ${PREFIX}/libexec/gprbuild/gprbind
	fperms 755 ${PREFIX}/libexec/gprbuild/gprlib
}

pkg_postinst () {
	einfo "GNAT GPL is now installed. To launch it, you must put"
	einfo "      ${PREFIX}/bin"
	einfo "in front of your PATH environment variable. The following"
	einfo "commands enable you to do this:"
	einfo "      PATH=${PREFIX}/bin:\$PATH; export PATH  (Bourne shell)"
	einfo "      setenv PATH ${PREFIX}/bin:\$PATH        (C shell)"
	einfo "   Thank you for installing GNAT GPL Edition"
}
