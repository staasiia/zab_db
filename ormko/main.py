from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Base, Obeti, Zabijaci
import local_settings

# Connect to the database
engine = create_engine(local_settings.DATABASE_URL)
Session = sessionmaker(bind=engine)
session = Session()

# Create tables (if they don't exist)
Base.metadata.create_all(engine)

#kontrola funkcnosti

#def fetch_all_victims():
 #   victims = session.query(Obeti).all()
  #  for victim in victims:
   #     print(victim.full_name, victim.misto_naroz, victim.vek_doziti)

#if __name__ == "__main__":
 #   fetch_all_victims()

 #def fetch_all_killers():
  #  killers = session.query(Zabijaci).all()
   # for killer in killers:
    #    print(killer.full_name, killer.misto_naroz, killer.vek_doziti)

#if __name__ == "__main__":
 #   fetch_all_killers()

# function

def child_procenta():
    # vsechny obeti
    total_victims = session.query(Obeti).count()

    # obeti where vekova_skupina = 'Dite'
    child_victims = session.query(Obeti).filter(Obeti.vekova_skupina == 'Dite').count()

    if total_victims > 0:
        percentage = (child_victims / total_victims) * 100
        print(f"Tolik procenta deti bylo zabito: {percentage:.2f}%")
    else:
        print("Zadne dite nebylo zabito.")

if __name__ == "__main__":
    child_procenta()


def fetch_victims_by_killer_id(killer_id):
    victims = session.query(Obeti).filter(Obeti.zabijaci_id == killer_id).all()
    for victim in victims:
        print(f"Victim Name: {victim.full_name}, Vek: {victim.vekova_skupina}")

if __name__ == "__main__":
    
    fetch_victims_by_killer_id(4)

