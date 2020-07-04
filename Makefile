SOURCE="https://www.softmaker.net/down/softmaker-office-2021_1016-01_amd64.deb"
DESTINATION="build.deb"
OUTPUT="SoftmakerOffice.AppImage"

all:
	echo "Building: $(OUTPUT)"
	wget --output-document=$(DESTINATION) --continue $(SOURCE)
	dpkg -x $(DESTINATION) build

	wget --output-document=build.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/libcurl-7.29.0-57.el7.x86_64.rpm
	rpm2cpio build.rpm | cpio -idmv

	wget --output-document=build.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/openssl-libs-1.0.2k-19.el7.x86_64.rpm
	rpm2cpio build.rpm | cpio -idmv

	mkdir -p ./AppDir/lib
	mkdir -p ./AppDir/application
	cp -r ./usr/lib64/* ./AppDir/lib
	cp -r ./build/usr/share/office2021/* ./AppDir/application

	export ARCH=x86_64 && bin/appimagetool.AppImage AppDir $(OUTPUT)
	chmod +x $(OUTPUT)

	rm -rf *.deb
	rm -rf *.rpm
	rm -rf ./build
	rm -rf ./usr
	rm -rf ./etc
	rm -rf ./AppDir/application
	rm -rf ./AppDir/lib
