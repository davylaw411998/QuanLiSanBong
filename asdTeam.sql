create database asdteam

create table San (
MaSan varchar(20) primary key,
TenSan varchar(20),
LoaiSan varchar(20),
MoTa nvarchar(50))

insert into San values ('S1','San bong 1','San 5',N'Sân cỏ nhân tạo')
insert into San values ('S2','San bong 2','San 5',N'Sân cỏ nhân tạo')

create table KhachHang (
MaKH int IDENTITY (1,1) primary key,
Username varchar(20) unique,
Pass varchar(20),
TenKH nvarchar(50),
SDT varchar(20) )

create table DatSan (
MaDatSan int identity (1,1) primary key,
MaKH int foreign key(MaKH) references KhachHang (MaKH),
MaSan varchar(20) foreign key(MaSan) references San (MaSan),
MaSuat varchar(20),
Ngay date )

create table TongSuat (
MaSan varchar(20),
MaSuat varchar(20),
Ngay date )

insert into TongSuat values ('S1','1',null)
insert into TongSuat values ('S1','2',null)
insert into TongSuat values ('S1','3',null)
insert into TongSuat values ('S1','4',null)

insert into TongSuat values ('S2','1',null)
insert into TongSuat values ('S2','2',null)
insert into TongSuat values ('S2','3',null)
insert into TongSuat values ('S2','4',null)

select * from TongSuat


alter procedure sp_TimSanTrong  (@loaisan varchar(20),
								 @ngay date,
								 @giodat varchar(20) )
as
	begin
		declare @masan_trong varchar(20)
		declare @masuat_trong varchar(20)
		declare @ngay_trong date
		drop table TimSan1
		update TongSuat set Ngay = @ngay
		select TongSuat.MaSan, MaSuat, Ngay into TimSan1 from TongSuat join San on  
			TongSuat.MaSan = San.MaSan
			where MaSuat=@giodat and San.LoaiSan = @loaisan
			except (select MaSan, MaSuat, Ngay from DatSan where MaSuat=@giodat) 
	end

sp_TimSanTrong 'San 5','2018/09/15','1'

select * from DatSan
select * from TimSan1

alter procedure sp_insertKH    (@username varchar(20),
								@pass varchar(20),
								@tenkh nvarchar(50),
								@sdt varchar(20) )
as
	begin
		insert into KhachHang (Username,Pass,TenKH,SDT) values (@username,@pass,@tenkh,@sdt)
	end

sp_insertKH 'Khachhang1','123',N'asd','0905'
sp_insertKH 'Khachhang2','123',N'asd','0905'
sp_insertKH 'Khachhang3','123',N'asd','0905'


select * from KhachHang
select * from DatSan
delete KhachHang




alter procedure sp_insertDatSan (  @masan varchar(20),
								   @masuat varchar(20),
							       @ngay date,
								   @username varchar(20) )
as
	begin
		declare @makh varchar(20)
		declare @masancheck varchar(20)

		set @makh = (select makh from KhachHang where username = @username)

		set @masancheck = (select masan from DatSan where Ngay = @ngay and MaSuat = @masuat and MaSan = @masan)

		if ((@masancheck is not null))
			begin
				print 'Dat san that bai!'
				rollback transaction
			end
		else
			begin
				print 'Dat san thanh cong!'
				insert into DatSan (MaKH,MaSan,MaSuat,Ngay) values (@makh,@masan,@masuat,@ngay)
			end
	end



sp_insertDatSan 'S1','1','2018/09/14','Khachhang1'
sp_insertDatSan 'S2','4','2018/09/14','Khachhang2'
sp_insertDatSan 'S1','2','2018/09/14'
sp_insertDatSan 'S2','2','2018/09/14'
sp_insertDatSan 'S1','3','2018/09/14'
sp_insertDatSan 'S1','4','2018/09/14'
sp_insertDatSan 'S2','3','2018/09/14'
sp_insertDatSan 'S2','4','2018/09/14'

select * from DatSan
select * from KhachHang
delete DatSan
select * from KhachHang
select * from DatSan
select * from San

select MaDatSan, MaKH, Datsan.MaSan, MaSuat from DatSan join san on DatSan.MaSan = san.masan where loaisan ='San 5'




