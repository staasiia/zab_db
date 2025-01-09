from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship, declarative_base

Base = declarative_base()

class Obeti(Base):
    __tablename__ = 'Obeti'
    obeti_id = Column(Integer, primary_key=True)
    full_name = Column(String(100))
    gender_id = Column(Integer, ForeignKey('Gender.gender_id'))
    vek_doziti = Column(Integer)
    misto_naroz = Column(String(40))
    zabijaci_id = Column(Integer, ForeignKey('Zabijaci.zabijaci_id'))
    pricina_id = Column(Integer, ForeignKey('Pricina_smrti.pricina_id'))
    vekova_skupina = Column(String(10))

    gender = relationship('Gender', back_populates='victims')
    killer = relationship('Zabijaci', back_populates='victims')
    reason = relationship('Pricina_smrti', back_populates='victims')
    
class Gender(Base):
    __tablename__ = 'Gender'
    gender_id = Column(Integer, primary_key=True)
    gender_name = Column(String(20))

    victims = relationship('Obeti', back_populates='gender')
    killers = relationship('Zabijaci', back_populates='gender')

class Zabijaci(Base):
    __tablename__ = 'Zabijaci'
    zabijaci_id = Column(Integer, primary_key=True)
    full_name = Column(String(40))
    gender_id = Column(Integer, ForeignKey('Gender.gender_id'))
    vek_doziti = Column(Integer)
    misto_naroz = Column(String(40))
    profil_id = Column(Integer, ForeignKey('Psychologicke_profily.profil_id'))
    zbrane_id = Column(Integer, ForeignKey('Zbrane.zbrane_id'))

    gender = relationship('Gender', back_populates='killers')  
    profile = relationship('Psychologicke_profily', back_populates='killers') 
    weapon = relationship('Zbrane', back_populates='killers')
    victims = relationship('Obeti', back_populates='killer')

class Psychologicke_profily(Base):
    __tablename__ = 'Psychologicke_profily'
    profil_id = Column(Integer, primary_key = True)
    profil_name = Column(String(100))

    killers = relationship('Zabijaci', back_populates = 'profile')

class Zbrane(Base):
    __tablename__ = 'Zbrane'
    zbrane_id = Column(Integer, primary_key = True)
    zbrane_name = Column(String(100))

    killers = relationship('Zabijaci', back_populates = 'weapon')

class Pricina_smrti(Base):
    __tablename__ = 'Pricina_smrti'
    pricina_id = Column(Integer, primary_key=True)
    pricina_name = Column(String(100))

    victims = relationship('Obeti', back_populates='reason')










