# Distributed under the terms of the GNU General Public License v2

EAPI="7"
SLOT="10"
LICENSE="GPL-2"

inherit multiprocessing flag-o-matic toolchain-funcs #check-reqs

DESCRIPTION="OpenJDK: open source implementation of Java programming language"
HOMEPAGE="http://openjdk.java.net/"

JDK_BUILD=$(ver_cut 5-)
JDK_VER=$(ver_cut 1-3)
SRC_TAG="jdk-${JDK_VER}+${JDK_BUILD}"

SRC_URI="
	http://hg.openjdk.java.net/jdk-updates/jdk${SLOT}u/archive/${SRC_TAG}.tar.bz2
	amd64? ( https://github.com/AdoptOpenJDK/openjdk${SLOT}-releases/releases/download/jdk-${JDK_VER}+${JDK_BUILD}/OpenJDK${SLOT}_x64_Linux_jdk-${JDK_VER}.${JDK_BUILD}.tar.gz )
"

KEYWORDS="amd64" # "~arm ~arm64 ~ppc64 ~x86"

OPENJDK_JVM_VARIANTS="server client minimal core zero"

for v in ${OPENJDK_JVM_VARIANTS}; do
	IUSE_JVM_VARIANTS+=" jvm_variant_${v}"
done

IUSE="${IUSE_JVM_VARIANTS} headless debug doc"

REQUIRED_USE="
	^^ ( || (
		jvm_variant_server
		jvm_variant_client
		jvm_variant_minimal
	) jvm_variant_core jvm_variant_zero )
"

RDEPEND="
	x11-libs/libXt
	x11-libs/libXtst
	x11-libs/libXrender
	net-print/cups
	media-libs/alsa-lib
"

DEPEND="
	${RDEPEND}
	app-arch/zip
"

CHECKREQS_DISK_BUILD="12G"

#pkg_pretend() {
#	check-reqs_pkg_pretend
#}

#pkg_setup() {
#	check-reqs_pkg_setup
#}

src_unpack() {
	default
	export S="${WORKDIR}/jdk${SLOT}u-${SRC_TAG}"
	export BOOT_JDK="${WORKDIR}/jdk-${JDK_VER}+${JDK_BUILD}"
}

src_configure() {
	chmod +x configure

	local jdk_target=${CTARGET:-${CHOST}}

	local jvm_variants=()

	for u in ${USE}; do
		if [[ $u =~ ^jvm_variant_ ]]; then
			jvm_variants+=(
				${u#jvm_variant_}
			) 
		fi
	done

	local ifs_original=${IFS}
	IFS=","
	local jvm_variants_build="${jvm_variants[*]}"
	IFS=${ifs_original}

	# Enabling full docs appears to break doc building. If not explicitly
	# disabled, the flag will get auto-enabled if pandoc and graphviz are
	# detected.
	local myconf=(
		--openjdk-target=${jdk_target}
		--with-jvm-variants=${jvm_variants_build}
		--enable-full-docs=no
		--with-version-pre=gentoo
		--with-version-string=${JDK_VER}
		--with-version-build=${JDK_BUILD}
	)

	if use headless ; then
		myconf+=(
			--enable-headless-only=yes
		)
	fi

	local extra_cflags=()

	if [[ $(gcc-major-version) -ge 7 ]]; then
		extra_cflags+=(
			-Wno-implicit-fallthrough
			-Wno-error=shift-negative-value
			-Wno-error=deprecated-declarations
			-Wno-error=misleading-indentation
			-Wno-error=maybe-uninitialized
			-Wno-error=uninitialized
		)
	fi

	append-cflags ${extra_cflags[@]}
	append-cxxflags ${extra_cflags[@]}

	set -- \
		--prefix="${EPREFIX}"/usr \
		--mandir="${EPREFIX}"/usr/share/man \
		--infodir="${EPREFIX}"/usr/share/info \
		--datadir="${EPREFIX}"/usr/share \
		--sysconfdir="${EPREFIX}"/etc \
		--localstatedir="${EPREFIX}"/var/lib \
		--with-boot-jdk="${BOOT_JDK}" \
		--with-extra-cflags="${CFLAGS}" \
		--with-extra-cxxflags="${CXXFLAGS}" \
		--with-extra-ldflags="${LDFLAGS}" \
		"${myconf[@]}"

	echo "${S}/configure" "$@"
	if ! "${S}/configure" "$@" ; then
		if [ -s config.log ]; then
			echo
			echo "!!! Please attach the following file when seeking support:"
			echo "!!! ${PWD}/config.log"
		fi
		die "econf failed"
	fi
}

src_compile() {
	local make_targets=(
		images
	)

	if use doc ; then
		make_targets+=(
			docs
		)
	fi

	set -- \
		"${make_targets[@]}" \
		JOBS=$(makeopts_jobs)

	echo "make" "$@"
	if ! "make" "$@"; then
		die "make failed"
	fi
}

src_install() {
	local jdk_image_dir="$( ls -d build/* )/images"
	if ! use debug ; then
		find ${jdk_image_dir}/jdk -name *.debuginfo -exec rm {} +
	fi

	insinto "/opt/${PN}-${SLOT}"
	doins -r ${jdk_image_dir}/jdk/*
	fperms -R 755 "/opt/${PN}-${SLOT}/bin"

	if use doc ; then
		insinto "/opt/${PN}-${SLOT}/doc"
		doins -r ${jdk_image_dir}/docs/*
	fi
}
